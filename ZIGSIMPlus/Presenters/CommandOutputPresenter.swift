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
    var accelerationMonitoringCommand: Command!
    var batteryMonitoringCommand: Command!
    private var output: String = ""
    
    func startCommands() {
        if AppSettingModel.shared.isAccelerationMonitoringActive {
            accelerationMonitoringCommand.start { (result) in
                self.updateOutput(with: result)
            }
        }
        
        if AppSettingModel.shared.isBatteryMonitoringActive {
            batteryMonitoringCommand.start { (result) in
                self.updateOutput(with: result)
            }
        }
    }
    
    func stopCommands() {
        accelerationMonitoringCommand.stop(completion: nil)
        batteryMonitoringCommand.stop(completion: nil)
    }
    
    private func updateOutput(with result: String?) {
        guard let r = result else { return }
        
        output += "\n" + r
        view.updateOutput(with: output)
    }
}
