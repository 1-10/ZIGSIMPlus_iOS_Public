//
//  NetworkAdapter.swift
//  ZIGSIMPlus
//
//  Created by Takayosi Amagi on 2019/05/22.
//  Copyright © 2019 1→10, Inc. All rights reserved.
//

import Foundation
import SwiftSocket
import CoreMotion

/// Wrapper of SwiftSocket.
public class NetworkAdapter {
    static let shared = NetworkAdapter()
    private init() {}

    var tcpClient: TCPClient = TCPClient(address: AppSettingModel.shared.ipAddress, port: Int32(AppSettingModel.shared.portNumber))
    var udpClient: UDPClient = UDPClient(address: AppSettingModel.shared.ipAddress, port: Int32(AppSettingModel.shared.portNumber))

    var error: Error?
    
    /// Send data over TCP / UDP automatically
    func send(_ data: Data) {
        switch AppSettingModel.shared.transportProtocol {
        case .TCP:
            sendTCP(data)
        case .UDP:
            sendUDP(data)
        }
    }

    func close() {
        udpClient.close()
        tcpClient.close()
    }

    /// Get error description to show in output view
    func getErrorLog() -> String? {
        if error == nil { return nil }

        switch error! {
        case SocketError.queryFailed:
            return "Socket Error: Host \(AppSettingModel.shared.ipAddress) not found"
        case SocketError.connectionClosed:
            return "Socket Error: Connection is closed"
        case SocketError.connectionTimeout:
            return "Socket Error: Connection timed out"
        case SocketError.unknownError:
            return "Socket Error: Unknown socket error"
        default:
            return "Socket Error: Unknown error"
        }
    }

    private func sendTCP(_ data: Data) {
        let appSetting = AppSettingModel.shared

        // Recreate client
        if tcpClient.address != appSetting.ipAddress || tcpClient.port != appSetting.portNumber {
            tcpClient.close()
            tcpClient = TCPClient(address: appSetting.ipAddress, port: Int32(appSetting.portNumber))
        }

        // Reopen connection if needed
        if tcpClient.fd == nil {
            switch tcpClient.connect(timeout: 1) {
            case .success:
                break
            case .failure(let e):
                error = e
                return
            }
        }

        // Send data
        switch tcpClient.send(data: data) {
        case .success:
            error = nil
        case .failure(let e):
            error = e
        }
    }

    private func sendUDP(_ data: Data) {
        let appSetting = AppSettingModel.shared

        // Recreate client
        if udpClient.fd == nil || udpClient.address != appSetting.ipAddress || udpClient.port != appSetting.portNumber {
            udpClient.close()
            udpClient = UDPClient(address: appSetting.ipAddress, port: Int32(appSetting.portNumber))
        }

        switch udpClient.send(data: data) {
        case .success:
            error = nil
        case .failure(let e):
            error = e
        }
    }
}
