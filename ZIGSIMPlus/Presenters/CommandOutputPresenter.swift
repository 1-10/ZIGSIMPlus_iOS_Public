//
//  CommandOutputPresenter.swift
//  ZIGSIMPlus
//
//  Created by Nozomu Kuwae on 5/10/19.
//  Copyright © 2019 Nozomu Kuwae. All rights reserved.
//

import Foundation

protocol CommandOutputPresenterProtocol {
    func startCommands()
    func stopCommands()
}

protocol CommandOutputPresenterDelegate: AnyObject {
    func updateOutput(with output: String)
}

final class CommandOutputPresenter: CommandOutputPresenterProtocol {
    var view: CommandOutputPresenterDelegate!
    var accelerationMonitoringCommand: AutoUpdatedCommand!
    var batteryMonitoringCommand: ManualUpdatedCommand!
    private var updatingTimer: Timer?
    private var resultDictionary: Dictionary<String, String> = [LabelConstants.Accelaration: "",
                                                                LabelConstants.Battery: ""]
    
    func startCommands() {
        initializeResult()
        updatingTimer = Timer.scheduledTimer(
            timeInterval: AppSettingModel.shared.messageInterval,
            target: self,
            selector: #selector(self.monitorCommands),
            userInfo: nil,
            repeats: true)

        if AppSettingModel.shared.isAccelerationMonitoringActive {
            accelerationMonitoringCommand.start { (result) in
                if let r = result {
                    self.resultDictionary[LabelConstants.Accelaration] = r
                }
            }
        }
        
        if AppSettingModel.shared.isBatteryMonitoringActive {
            batteryMonitoringCommand.start { (result) in
                if let r = result {
                    self.resultDictionary[LabelConstants.Battery] = r
                }
            }
        }
        
        updateOutput()
    }
    
    @objc private func monitorCommands() {
        if AppSettingModel.shared.isBatteryMonitoringActive {
            batteryMonitoringCommand.monitor { (result) in
                if let r = result {
                    self.resultDictionary[LabelConstants.Battery] = r
                }
            }
        }
        
        updateOutput()
    }
    
    func stopCommands() {
        guard let t = updatingTimer else { return }
        if t.isValid {
            t.invalidate()
        }
        
        accelerationMonitoringCommand.stop(completion: nil)
        batteryMonitoringCommand.stop(completion: nil)
    }
    
    private func updateOutput() {
        var result = ""
        result += (resultDictionary[LabelConstants.Accelaration]!.count > 0 ? resultDictionary[LabelConstants.Accelaration]! + "\n" : "")
        result += (resultDictionary[LabelConstants.Battery]!.count > 0 ? resultDictionary[LabelConstants.Battery]! + "\n" : "")
        view.updateOutput(with: result)
    }
    
    private func initializeResult() {
        resultDictionary.keys.forEach { resultDictionary[$0] = "" }
    }
}
