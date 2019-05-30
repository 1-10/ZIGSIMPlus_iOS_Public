//
//  CommandDataOutputPresenter.swift
//  ZIGSIMPlus
//
//  Created by Nozomu Kuwae on 5/10/19.
//  Copyright © 2019 Nozomu Kuwae. All rights reserved.
//

import Foundation
import UIKit

protocol CommandDataOutputPresenterProtocol {
    func startCommands()
    func stopCommands()
}

protocol CommandDataOutputPresenterDelegate: AnyObject {
    func updateOutput(with output: String)
    func updateImagePreview(with image: UIImage)
    func setImageViewActive(_ active: Bool)
    func setSceneViewActive(_ active: Bool)
}

final class CommandDataOutputPresenter: CommandDataOutputPresenterProtocol {
    private weak var view: CommandDataOutputPresenterDelegate!
    private var mediator: CommandAndCommandDataMediator
    private var resultByCommand: Dictionary<Int, String> = [:]
    private var updatingTimer: Timer?
    
    init(view: CommandDataOutputPresenterDelegate, mediator: CommandAndCommandDataMediator) {
        self.view = view
        self.mediator = mediator
    }
    
    // MARK: Start commands
    func startCommands() {
        initializeResults()
        initializeView()
        updatingTimer = Timer.scheduledTimer(
            timeInterval: AppSettingModel.shared.messageInterval,
            target: self,
            selector: #selector(self.monitorCommands),
            userInfo: nil,
            repeats: true)
        
        for command in mediator.commands {
            if mediator.isActive(command: command) {
                switch command {
                case let c as ImageCommand:
                    c.startImage { (image) in
                        self.updateImagePreview(with: image)
                    }
                default:
                    command.start { (result) in
                        self.storeResult(result, of: command)
                    }
                }
            }
        }

        StoreManager.shared.send()
        updateOutput()
    }
    
    private func initializeResults() {
        for (key, _) in resultByCommand {
            resultByCommand[key] = ""
        }
    }

    private func initializeView() {
        let isImageViewActive = AppSettingModel.shared.isActiveByCommandData[Label.ndi]!
        view.setImageViewActive(isImageViewActive)

        let isSceneViewActive = (
            AppSettingModel.shared.isActiveByCommandData[Label.arkit]! ||
            AppSettingModel.shared.isActiveByCommandData[Label.faceTracking]!
        )
        view.setSceneViewActive(isSceneViewActive)
    }

    // MARK: Monitor commands
    @objc private func monitorCommands() {
        for command in mediator.commands {
            if mediator.isActive(command: command) && command is ManualUpdatedCommand {
                let c = command as! ManualUpdatedCommand
                c.monitor { (result) in
                    self.storeResult(result, of: command)
                }
            }
        }

        StoreManager.shared.send()
        updateOutput()
    }
    
    
    // MARK: Stop commands
    func stopCommands() {
        guard let t = updatingTimer else { return }
        if t.isValid {
            t.invalidate()
        }
        
        for command in mediator.commands {
            if mediator.isActive(command: command) {
                command.stop(completion: nil)
            }
        }
        StoreManager.shared.send()
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
    
    private func updateImagePreview(with image: UIImage) {
        view.updateImagePreview(with: image)
    }
}
