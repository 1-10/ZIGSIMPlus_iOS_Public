//
//  NetworkAdapter.swift
//  ZIGSIMPlus
//
//  Created by Takayosi Amagi on 2019/05/22.
//  Copyright © 2019 Nozomu Kuwae. All rights reserved.
//

import Foundation
import SwiftSocket

public class NetworkAdapter {
    static let shared = NetworkAdapter()
    
    func sendMessage(data: Data){        
        switch AppSettingModel.shared.transportProtocol {
        case .TCP:
            sendTCP(data)
        case .UDP:
            sendUDP(data)
        }
    }

    private func sendTCP(_ data: Data) {
        let appSetting = AppSettingModel.shared
        let client = TCPClient(address: appSetting.address, port: appSetting.port)
        switch client.connect(timeout: 1) {
        case .success:
            switch client.send(data: data) {
            case .success:
                print(">> TCP sending data succeeded")
            case .failure(let error):
                print(">> TCP sending data failed: \(error.localizedDescription)")
            }
            client.close()
        case .failure(let error):
            print(">> TCP connection failed: \(error.localizedDescription)")
        }
    }
    
    private func sendUDP(_ data: Data) {
        let appSetting = AppSettingModel.shared
        let client = UDPClient(address: appSetting.address, port: appSetting.port)
        switch client.send(data: data) {
        case .success:
            print(">> UDP sending data succeeded")
        case .failure(let error):
            print(">> UDP sending data failed: \(error.localizedDescription)")
        }
        client.close()
    }
}
