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
    var autoUpdatedCommands: Dictionary<String, AutoUpdatedCommand> = [:]
    var manualUpdatedCommands: Dictionary<String, ManualUpdatedCommand> = [:]
    private var resultByCommand: Dictionary<String, String> = [:]
    private var updatingTimer: Timer?
    
    
    // MARK: Start commands
    func startCommands() {
        initializeResults()
        updatingTimer = Timer.scheduledTimer(
            timeInterval: AppSettingModel.shared.messageInterval,
            target: self,
            selector: #selector(self.monitorCommands),
            userInfo: nil,
            repeats: true)

        for label in LabelConstants.autoUpdatedCommands {
            startAutoUpdatedCommand(of: label)
        }
        
        for label in LabelConstants.manualUpdatedCommands {
            startManualUpdatedCommand(of: label)
        }

        updateOutput()
    }
    
    private func startAutoUpdatedCommand(of label: String) {
        guard let isActive = AppSettingModel.shared.isActiveByCommand[label],
            let command = autoUpdatedCommands[label] else { return }
        if isActive {
            command.start { (result) in
                guard let r = result else { return }
                self.resultByCommand[label] = r
            }
        }
    }
    
    private func startManualUpdatedCommand(of label: String) {
        guard let isActive = AppSettingModel.shared.isActiveByCommand[label],
            let command = manualUpdatedCommands[label] else { return }
        if isActive {
            command.start { (result) in
                guard let r = result else { return }
                self.resultByCommand[label] = r
            }
        }
    }
    
    private func initializeResults() {
        for label in LabelConstants.commands {
            resultByCommand[label] = ""
        }
    }
    
    
    // MARK: Monitor commands
    @objc private func monitorCommands() {
        for label in LabelConstants.manualUpdatedCommands {
            monitorManualUpdatedCommand(of: label)
        }

        updateOutput()
    }
    
    private func monitorManualUpdatedCommand(of label: String) {
        guard let isActive = AppSettingModel.shared.isActiveByCommand[label],
            let command = manualUpdatedCommands[label] else { return }
        if isActive {
            command.monitor { (result) in
                guard let r = result else { return }
                self.resultByCommand[label] = r
            }
        }
    }
    
    
    // MARK: Stop commands
    func stopCommands() {
        guard let t = updatingTimer else { return }
        if t.isValid {
            t.invalidate()
        }
        
        for label in LabelConstants.autoUpdatedCommands {
            autoUpdatedCommands[label]?.stop(completion: nil)
        }

        for label in LabelConstants.manualUpdatedCommands {
            manualUpdatedCommands[label]?.stop(completion: nil)
        }
    }
    
    
    // MARK: Methods used in multiple timings
    private func updateOutput() {
        var output = ""
        
        for label in LabelConstants.commands {
            guard let r = resultByCommand[label] else { continue }
            output += (r.count > 0 ? r + "\n" : "")
        }
        
        view.updateOutput(with: output)
    }
}
