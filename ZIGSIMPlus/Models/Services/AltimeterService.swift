//
//  AltimeterService.swift
//  ZIGSIMPlus
//
//  Created by YoneyamaShunpei on 2019/05/22.
//  Copyright © 2019 1→10, Inc. All rights reserved.
//

import CoreMotion
import Foundation
import OSCKit
import SwiftyJSON

public class AltimeterService {
    // Singleton instance
    static let shared = AltimeterService()

    // MARK: - Instance Properties

    var altimeter = CMAltimeter()
    var isWorking: Bool
    var pressureData: Double
    var altitudeData: Double
    var callbackAltimeter: (([Double]) -> Void)?

    private init() {
        isWorking = false
        pressureData = 0.0
        altitudeData = 0.0
        callbackAltimeter = nil
    }

    private func updateAltimeterData() {
        var altimeterData = [0.0, 0.0]
        altimeterData[0] = pressureData
        altimeterData[1] = altitudeData
        callbackAltimeter?(altimeterData)
    }

    // MARK: - Public methods

    func isAvailable() -> Bool {
        return CMAltimeter.isRelativeAltitudeAvailable()
    }

    func startAltimeter() {
        if CMAltimeter.isRelativeAltitudeAvailable() {
            isWorking = true
            altimeter.startRelativeAltitudeUpdates(
                to: OperationQueue.main,
                withHandler: { [weak self] data, error in
                    guard let self = self else { return }
                    if error == nil {
                        guard let data = data else { return }
                        self.pressureData = Double(truncating: data.pressure) * 10.0
                        self.altitudeData = Double(truncating: data.relativeAltitude)
                        self.updateAltimeterData()
                    }
                }
            )
        }
    }

    func stopAltimeter() {
        if isWorking {
            isWorking = false
            altimeter.stopRelativeAltitudeUpdates()
        }
    }
}

extension AltimeterService: Service {
    func toLog() -> [String] {
        var log = [String]()

        if AppSettingModel.shared.isActiveByCommand[Command.pressure] ?? false {
            log += [
                "pressure:pressure:\(pressureData)",
                "pressure:altitude:\(altitudeData)",
            ]
        }

        return log
    }

    func toOSC() -> [OSCMessage] {
        var messages = [OSCMessage]()

        if AppSettingModel.shared.isActiveByCommand[Command.pressure] ?? false {
            messages.append(osc("pressure", pressureData, altitudeData))
        }

        return messages
    }

    func toJSON() -> JSON {
        var data = JSON()

        if AppSettingModel.shared.isActiveByCommand[Command.pressure] ?? false {
            data["pressure"] = [
                "pressure": pressureData,
                "altitude": altitudeData,
            ]
        }

        return data
    }
}
