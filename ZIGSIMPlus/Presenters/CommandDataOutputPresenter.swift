//
//  CommandDataOutputPresenter.swift
//  ZIGSIMPlus
//
//  Created by Nozomu Kuwae on 5/10/19.
//  Copyright © 2019 Nozomu Kuwae. All rights reserved.
//

import Foundation

protocol CommandDataOutputPresenterProtocol {
    func startCommands()
    func stopCommands()
}

protocol CommandDataOutputPresenterDelegate: AnyObject {
    func updateOutput(with output: String)
}

final class CommandDataOutputPresenter: CommandDataOutputPresenterProtocol {
    var view: CommandDataOutputPresenterDelegate!
    var commands: [Command] = []
    var mediator: CommandAndCommandDataMediator!
    private var resultByCommand: Dictionary<Int, String> = [:]
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
        
        for command in commands {
            if mediator.isActive(command: command) {
                command.start { (result) in
                    self.storeResult(result, of: command)
                }
            }
        }

        updateOutput()
    }
    
    private func initializeResults() {
        for (key, _) in resultByCommand {
            resultByCommand[key] = ""
        }
    }
    
    
    // MARK: Monitor commands
    @objc private func monitorCommands() {
        for command in commands {
            if mediator.isActive(command: command) && command is ManualUpdatedCommand {
                let c = command as! ManualUpdatedCommand
                c.monitor { (result) in
                    self.storeResult(result, of: command)
                }
            }
        }

        updateOutput()
    }
    
    
    // MARK: Stop commands
    func stopCommands() {
        guard let t = updatingTimer else { return }
        if t.isValid {
            t.invalidate()
        }
        
        for command in commands {
            if mediator.isActive(command: command) {
                command.stop(completion: nil)
            }
        }
    }
    
    
    // MARK: Methods used in multiple timings
    private func storeResult(_ result: String?, of command: Command) {
        guard let r = result else { return }
        self.resultByCommand[self.mediator.getCommandOutputOrder(of: command)] = r
    }
    
    private func updateOutput() {
        var output = ""
        
        for (_, value) in resultByCommand.sorted(by: <) {
            output += (value.count > 0 ? value + "\n" : "")
        }
        view.updateOutput(with: output)
    }
}
