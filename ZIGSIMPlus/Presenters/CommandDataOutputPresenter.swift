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
}

final class CommandDataOutputPresenter: CommandDataOutputPresenterProtocol {
    private weak var view: CommandDataOutputPresenterDelegate!
    private var mediator: CommandAndServiceMediator
    private var updatingTimer: Timer?
    
    init(view: CommandDataOutputPresenterDelegate, mediator: CommandAndServiceMediator) {
        self.view = view
        self.mediator = mediator
    }
    
    // MARK: Start commands
    func startCommands() {
        updatingTimer = Timer.scheduledTimer(
            timeInterval: AppSettingModel.shared.messageInterval,
            target: self,
            selector: #selector(self.monitorCommands),
            userInfo: nil,
            repeats: true)

        for label in CommandDataLabels {
            if mediator.isActive(label) {
                mediator.startCommand(label)
            }
        }

        ServiceManager.shared.send()
        updateOutput()
    }

    // MARK: Monitor commands
    @objc private func monitorCommands() {
        for label in CommandDataLabels {
            if mediator.isActive(label) && mediator.isManual(label) {
                mediator.update(label)
            }
        }

        ServiceManager.shared.send()
        updateOutput()
    }
    
    
    // MARK: Stop commands
    func stopCommands() {
        guard let t = updatingTimer else { return }
        if t.isValid {
            t.invalidate()
        }

        for label in CommandDataLabels {
            if mediator.isActive(label) {
                mediator.stopCommand(label)
            }
        }
        ServiceManager.shared.send()
    }
    
    
    // MARK: Methods used in multiple timings

    private func updateOutput() {
        view.updateOutput(with: ServiceManager.shared.getLog())
    }
}
