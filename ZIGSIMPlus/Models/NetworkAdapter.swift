//
//  NetworkAdapter.swift
//  ZIGSIMPlus
//
//  Created by Takayosi Amagi on 2019/05/22.
//  Copyright © 2019 1-10, Inc. All rights reserved.
//

import Foundation
import Network

/// Wrapper for TCP/UDP networking using Apple's Network.framework.
public class NetworkAdapter {
    static let shared = NetworkAdapter()
    private init() {}

    private var tcpConnection: NWConnection?
    private var currentTCPAddress: String = ""
    private var currentTCPPort: Int = 0

    private let networkQueue = DispatchQueue(label: "com.zigsim.network")

    var error: Error?

    enum NetworkError: Error {
        case queryFailed
        case connectionClosed
        case connectionTimeout
        case unknownError
    }

    /// Send data over TCP / UDP automatically
    func send(_ data: Data) {
        networkQueue.async {
            switch AppSettingModel.shared.transportProtocol {
            case .TCP:
                self.sendTCP(data)
            case .UDP:
                self.sendUDP(data)
            }
        }
    }

    func close() {
        tcpConnection?.cancel()
        tcpConnection = nil
    }

    /// Get error description to show in output view
    func getErrorLog() -> String? {
        guard let error = error else { return nil }

        switch error {
        case NetworkError.queryFailed:
            return "Socket Error: Host \(AppSettingModel.shared.ipAddress) not found"
        case NetworkError.connectionClosed:
            return "Socket Error: Connection is closed"
        case NetworkError.connectionTimeout:
            return "Socket Error: Connection timed out"
        default:
            return "Socket Error: Unknown error"
        }
    }

    private var isTCPReady: Bool {
        guard let conn = tcpConnection else { return false }
        if case .ready = conn.state { return true }
        return false
    }

    private func sendTCP(_ data: Data) {
        assert(!Thread.isMainThread)

        let appSetting = AppSettingModel.shared
        let address = appSetting.ipAddress
        let port = appSetting.portNumber

        // Recreate connection if address/port changed
        if address != currentTCPAddress || port != currentTCPPort {
            tcpConnection?.cancel()
            tcpConnection = nil
            currentTCPAddress = address
            currentTCPPort = port
        }

        // Create and connect if needed
        if !isTCPReady {
            guard let nwPort = NWEndpoint.Port(rawValue: UInt16(port)) else {
                error = NetworkError.queryFailed
                return
            }

            let conn = NWConnection(host: NWEndpoint.Host(address), port: nwPort, using: .tcp)
            tcpConnection = conn

            let semaphore = DispatchSemaphore(value: 0)
            var connectError: Error?

            conn.stateUpdateHandler = { state in
                switch state {
                case .ready:
                    semaphore.signal()
                case .failed(let err):
                    connectError = err
                    semaphore.signal()
                case .cancelled:
                    connectError = NetworkError.connectionClosed
                    semaphore.signal()
                default:
                    break
                }
            }
            conn.start(queue: networkQueue)

            if semaphore.wait(timeout: .now() + 1.0) == .timedOut {
                conn.cancel()
                tcpConnection = nil
                error = NetworkError.connectionTimeout
                return
            }

            if let err = connectError {
                tcpConnection = nil
                error = mapNWError(err)
                return
            }
        }

        guard let conn = tcpConnection, isTCPReady else {
            tcpConnection = nil
            error = NetworkError.connectionClosed
            return
        }

        let semaphore = DispatchSemaphore(value: 0)
        var sendError: Error?

        conn.send(content: data, completion: .contentProcessed { nwError in
            sendError = nwError
            semaphore.signal()
        })

        semaphore.wait()

        if let err = sendError {
            tcpConnection = nil
            error = mapNWError(err)
        } else {
            error = nil
        }
    }

    private func sendUDP(_ data: Data) {
        assert(!Thread.isMainThread)

        let appSetting = AppSettingModel.shared

        guard let nwPort = NWEndpoint.Port(rawValue: UInt16(appSetting.portNumber)) else {
            error = NetworkError.queryFailed
            return
        }

        let conn = NWConnection(
            host: NWEndpoint.Host(appSetting.ipAddress),
            port: nwPort,
            using: .udp
        )

        let semaphore = DispatchSemaphore(value: 0)
        var sendError: Error?

        conn.stateUpdateHandler = { [weak self] state in
            switch state {
            case .ready:
                conn.send(content: data, completion: .contentProcessed { nwError in
                    sendError = nwError
                    conn.cancel()
                    semaphore.signal()
                })
            case .failed(let err):
                sendError = err
                semaphore.signal()
            default:
                break
            }
        }
        conn.start(queue: networkQueue)

        if semaphore.wait(timeout: .now() + 1.0) == .timedOut {
            conn.cancel()
            error = NetworkError.connectionTimeout
        } else if let err = sendError {
            error = mapNWError(err)
        } else {
            error = nil
        }
    }

    private func mapNWError(_ err: Error) -> NetworkError {
        guard let nwErr = err as? NWError else { return .unknownError }
        switch nwErr {
        case .dns:
            return .queryFailed
        case .posix(let code):
            switch code {
            case .ETIMEDOUT: return .connectionTimeout
            case .ECONNRESET, .ENOTCONN, .ECONNREFUSED: return .connectionClosed
            default: return .unknownError
            }
        default:
            return .unknownError
        }
    }
}
