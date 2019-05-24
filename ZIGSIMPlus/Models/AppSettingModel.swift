//
//  AppSettingModel.swift
//  ZIGSIMPlus
//
//  Created by Nozomu Kuwae on 5/10/19.
//  Copyright © 2019 Nozomu Kuwae. All rights reserved.
//

import Foundation

public class AppSettingModel {
    static let ud = UserDefaults.standard
    private init() {
        for label in LabelConstants.commandDatas {
            isActiveByCommandData[label] = false
        }
    }
    
    static let shared = AppSettingModel()
    var isActiveByCommandData: Dictionary<String, Bool> = [:]
    
    // TODO: default data
    var dataDestination: String = "OTHER_APP"
    var protocolo: String = "UDP"
    var ipAdress: String = "192.168.0.1"
    var portNumber: String = "50000"
    var messageFormat: String = "JSON"
    var messageRatePerSecond: Int = 60
    var compassAngle: Double = 1.0 // 1.0 is faceup
    var deviceUUID: String = Utils.randomStringWithLength(16)
    var beaconUUID = "B9407F30-F5F8-466E-AFF9-25556B570000"
    
    var messageInterval: TimeInterval {
        return 1.0 / Double(messageRatePerSecond)
    }
    
    // computed properties as class variables
    class var userDataDestination: String {
        get {
            ud.register(defaults: ["userDataDestination": self.shared.dataDestination])
            return ud.object(forKey: "userDataDestination") as! String
        }
        set(newValue) {
            ud.set(newValue, forKey: "userDataDestination")
            ud.synchronize()
        }
    }
    
    class var userProtocolo: String {
        get {
            ud.register(defaults: ["userProtocolo": self.shared.protocolo])
            return ud.object(forKey: "userProtocolo") as! String
        }
        set(newValue) {
            ud.set(newValue, forKey: "userProtocolo")
            ud.synchronize()
        }
    }
    
    class var userIpAdress: String {
        get {
            ud.register(defaults: ["userIpAdress": self.shared.ipAdress])
            return ud.object(forKey: "userIpAdress") as! String
        }
        set(newValue) {
            ud.set(newValue, forKey: "userIpAdress")
            ud.synchronize()
        }
    }
    
    class var userPortNumber: String {
        get {
            ud.register(defaults: ["userPortNumber": self.shared.portNumber])
            return ud.object(forKey: "userPortNumber") as! String
        }
        set(newValue) {
            ud.set(newValue, forKey: "userPortNumber")
            ud.synchronize()
        }
    }
    
    class var userMessageFormat: String {
        get {
            ud.register(defaults: ["userMessageFormat": self.shared.messageFormat])
            return ud.object(forKey: "userMessageFormat") as! String
        }
        set(newValue) {
            ud.set(newValue, forKey: "userMessageFormat")
            ud.synchronize()
        }
    }
    
    class var userMessageRatePerSecond: Int {
        get {
            ud.register(defaults: ["userMessageRatePerSecond": self.shared.messageRatePerSecond])
            return ud.object(forKey: "userMessageRatePerSecond") as! Int
        }
        set(newValue) {
            ud.set(newValue, forKey: "userMessageRatePerSecond")
            ud.synchronize()
        }
    }
    
    class var userCompassAngle: Double {
        get {
            ud.register(defaults: ["userCompassAngle": self.shared.compassAngle])
            return ud.object(forKey: "userCompassAngle") as! Double
        }
        set(newValue) {
            ud.set(newValue, forKey: "userCompassAngle")
            ud.synchronize()
        }
    }
    
    class var userDeviceUUID: String {
        get {
            ud.register(defaults: ["userDeviceUUID": self.shared.deviceUUID])
            return ud.object(forKey: "userDeviceUUID") as! String
        }
        set(newValue) {
            ud.set(newValue, forKey: "userDeviceUUID")
            ud.synchronize()
        }
    }
    
    class var userBeaconUUID: String {
        get {
            ud.register(defaults: ["userBeaconUUID": self.shared.beaconUUID])
            return ud.object(forKey: "userBeaconUUID") as! String
        }
        set(newValue) {
            ud.set(newValue, forKey: "userBeaconUUID")
            ud.synchronize()
        }
    }
}

