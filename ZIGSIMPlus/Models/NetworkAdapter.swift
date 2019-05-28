//
//  NetworkAdapter.swift
//  ZIGSIMPlus
//
//  Created by Takayosi Amagi on 2019/05/22.
//  Copyright © 2019 Nozomu Kuwae. All rights reserved.
//

import Foundation
import SwiftSocket
import CoreMotion

/// Wrapper of SwiftSocket.
public class NetworkAdapter {
    static let shared = NetworkAdapter()
    private init() {}

    var tcpClient: TCPClient = TCPClient(address: AppSettingModel.shared.address, port: AppSettingModel.shared.port)
    var udpClient: UDPClient = UDPClient(address: AppSettingModel.shared.address, port: AppSettingModel.shared.port)
    
    /// Send data over TCP / UDP automatically
    func send(_ data: Data){
        switch AppSettingModel.shared.transportProtocol {
        case .TCP:
            sendTCP(data)
        case .UDP:
            sendUDP(data)
        }
    }

    private func sendTCP(_ data: Data) {
        let appSetting = AppSettingModel.shared

        // Recreate client
        if tcpClient.address != appSetting.address || tcpClient.port != appSetting.port {
            tcpClient.close()
            tcpClient = TCPClient(address: appSetting.address, port: appSetting.port)
        }

        // Reopen connection if needed
        if tcpClient.fd == nil {
            switch tcpClient.connect(timeout: 1) {
            case .success:
                print(">> TCP connection succeeded")
            case .failure(let error):
                print(">> TCP connection failed: \(error.localizedDescription)")
                return
            }
        }

        // Send data
        switch tcpClient.send(data: data) {
        case .success:
            print(">> TCP sending data succeeded")
        case .failure(let error):
            print(">> TCP sending data failed: \(error.localizedDescription)")
        }
    }

    private func sendUDP(_ data: Data) {
        let appSetting = AppSettingModel.shared

        // Recreate client
        if udpClient.fd == nil || udpClient.address != appSetting.address || udpClient.port != appSetting.port {
            udpClient.close()
            udpClient = UDPClient(address: appSetting.address, port: appSetting.port)
        }

        switch udpClient.send(data: data) {
        case .success:
            print(">> UDP sending data succeeded")
        case .failure(let error):
            print(">> UDP sending data failed: \(error.localizedDescription)")
        }
    }
}
