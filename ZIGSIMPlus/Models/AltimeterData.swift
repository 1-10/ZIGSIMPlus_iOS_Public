//
//  AltimeterData.swift
//  ZIGSIMPlus
//
//  Created by YoneyamaShunpei on 2019/05/22.
//  Copyright © 2019 Nozomu Kuwae. All rights reserved.
//

import Foundation
import CoreMotion

public class AltimeterData{
    // Singleton instance
    static let shared = AltimeterData()
    
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
