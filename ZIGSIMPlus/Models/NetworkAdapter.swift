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

    private let connectionQueue = DispatchQueue(label: "com.zigsim.network.connection")

    var error: Error?

    enum NetworkError: Error {
        case queryFailed
        case connectionClosed
        case connectionTimeout
        case unknownError
    }

    private final class ConnectionContinuationGate: @unchecked Sendable {
        private let lock = NSLock()
        private var continuation: CheckedContinuation<Void, Error>?

        init(_ continuation: CheckedContinuation<Void, Error>) {
            self.continuation = continuation
        }

        @discardableResult
        func resume(returning value: Void = ()) -> Bool {
            lock.lock()
            guard let continuation = continuation else {
                lock.unlock()
                return false
            }
            self.continuation = nil
            lock.unlock()

            continuation.resume(returning: value)
            return true
        }

        @discardableResult
        func resume(throwing error: Error) -> Bool {
            lock.lock()
            guard let continuation = continuation else {
                lock.unlock()
                return false
            }
            self.continuation = nil
            lock.unlock()

            continuation.resume(throwing: error)
            return true
        }
    }

    /// Send data over TCP / UDP automatically
    func send(_ data: Data) async throws {
        switch AppSettingModel.shared.transportProtocol {
        case .TCP:
            try await sendTCP(data)
        case .UDP:
            sendUDP(data)
            if let error = error {
                throw error
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

    private func sendTCP(_ data: Data) async throws {
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
                throw NetworkError.queryFailed
            }

            let conn = NWConnection(host: NWEndpoint.Host(address), port: nwPort, using: .tcp)
            tcpConnection = conn

            do {
                try await connectTCP(conn)
            } catch {
                tcpConnection = nil
                let networkError = mapNetworkError(error)
                self.error = networkError
                throw networkError
            }
        }

        guard let conn = tcpConnection, isTCPReady else {
            tcpConnection = nil
            error = NetworkError.connectionClosed
            throw NetworkError.connectionClosed
        }

        do {
            try await sendTCP(data, on: conn)
            error = nil
        } catch {
            tcpConnection = nil
            let networkError = mapNetworkError(error)
            self.error = networkError
            throw networkError
        }
    }

    private func connectTCP(_ conn: NWConnection) async throws {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            let gate = ConnectionContinuationGate(continuation)

            conn.stateUpdateHandler = { state in
                switch state {
                case .ready:
                    gate.resume()
                case .failed(let err):
                    gate.resume(throwing: err)
                case .cancelled:
                    gate.resume(throwing: NetworkError.connectionClosed)
                default:
                    break
                }
            }
            conn.start(queue: connectionQueue)

            connectionQueue.asyncAfter(deadline: .now() + 1.0) {
                if gate.resume(throwing: NetworkError.connectionTimeout) {
                    conn.cancel()
                }
            }
        }
    }

    private func sendTCP(_ data: Data, on conn: NWConnection) async throws {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            conn.send(content: data, completion: .contentProcessed { nwError in
                if let nwError = nwError {
                    continuation.resume(throwing: nwError)
                } else {
                    continuation.resume()
                }
            })
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

        conn.stateUpdateHandler = { state in
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
        conn.start(queue: connectionQueue)

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

    private func mapNetworkError(_ err: Error) -> NetworkError {
        if let networkError = err as? NetworkError {
            return networkError
        }
        return mapNWError(err)
    }
}
