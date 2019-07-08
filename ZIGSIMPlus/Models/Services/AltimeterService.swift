//
//  AltimeterService.swift
//  ZIGSIMPlus
//
//  Created by YoneyamaShunpei on 2019/05/22.
//  Copyright © 2019 1→10, Inc. All rights reserved.
//

import Foundation
import CoreMotion
import SwiftOSC
import SwiftyJSON

public class AltimeterService {
    // Singleton instance
    static let shared = AltimeterService()

    // MARK: - Instance Properties
    var altimeter: AnyObject!
    var isWorking: Bool
    var pressureData: Double
    var altitudeData: Double
    var callbackAltimeter: (([Double]) -> Void)?

    private init() {
        isWorking = false
        pressureData = 0.0
        altitudeData = 0.0
        callbackAltimeter = nil
        if #available(iOS 8.0, *) {
            altimeter = CMAltimeter()
        } else {
            altimeter = false as AnyObject
        }

    }

    private func updateAltimeterData() {
        print("pressure:pressure: \(self.pressureData)")
        print("pressure:altitude: \(self.altitudeData)")
        var altimeterData = [0.0,0.0]
        altimeterData[0] = self.pressureData
        altimeterData[1] = self.altitudeData
        callbackAltimeter?(altimeterData)
    }

    // MARK: - Public methods

    func isAvailable() -> Bool {
        if #available(iOS 8.0, *) {
            return CMAltimeter.isRelativeAltitudeAvailable()
        }
        return false
    }

    func startAltimeter() {
        if #available(iOS 8.0, *) {
            if CMAltimeter.isRelativeAltitudeAvailable() {
                isWorking = true
                altimeter.startRelativeAltitudeUpdates(to: OperationQueue.main, withHandler: { (data, error) in
                    if error == nil {
                        self.pressureData = Double(truncating: data!.pressure) * 10.0
                        self.altitudeData = Double(truncating: data!.relativeAltitude)
                        self.updateAltimeterData()
                    }
                })
            }
        } else {
            // Fallback on earlier versions
        }
    }

    func stopAltimeter() {
        if isWorking {
            isWorking = false
            altimeter.stopRelativeAltitudeUpdates()
        }
    }
}

extension AltimeterService : Service {
    func toLog() -> [String] {
        var log = [String]()

        if AppSettingModel.shared.isActiveByCommand[Command.pressure]! {
            log += [
                "pressure:pressure:\(pressureData)",
                "pressure:altitude:\(altitudeData)",
            ]
        }

        return log
    }

    func toOSC() -> [OSCMessage] {
        let deviceUUID = AppSettingModel.shared.deviceUUID
        var messages = [OSCMessage]()

        if AppSettingModel.shared.isActiveByCommand[Command.pressure]! {
            messages.append(OSCMessage(
                OSCAddressPattern("/\(deviceUUID)/pressure"),
                pressureData,
                altitudeData
            ))
        }

        return messages
    }

    func toJSON() -> JSON {
        var data = JSON()

        if AppSettingModel.shared.isActiveByCommand[Command.pressure]! {
            data["pressure"] = [
                "pressure": pressureData,
                "altitude": altitudeData
            ]
        }

        return data
    }
}
