//
//  CommandOutputPresenter.swift
//  ZIGSIMPlus
//
//  Created by Nozomu Kuwae on 5/10/19.
//  Copyright © 2019 Nozomu Kuwae. All rights reserved.
//

import Foundation
import UIKit

protocol CommandOutputPresenterProtocol {
    func composeChildViewArchitecture()
    func startCommands()
    func stopCommands()
    func isCameraUsed() -> Bool
    func isTouchEnabled() -> Bool
}

protocol CommandOutputPresenterDelegate: AnyObject {
    func updateOutput(with log: String, errorLog: String)
    func updateSettings(with settings: [(String, String)])
}

final class CommandOutputPresenter: CommandOutputPresenterProtocol {
    private weak var view: CommandOutputPresenterDelegate!
    private var mediator: CommandAndServiceMediator
    private var updatingTimer: Timer?
    
    init(view: CommandOutputPresenterDelegate, mediator: CommandAndServiceMediator) {
        self.view = view
        self.mediator = mediator
    }
    
    // This cannnot be defined in AppDelegate, because subviews cannot be accessed from AppDelegate
    // https://stackoverflow.com/questions/50780404/swift-how-to-reference-subview-from-appdelegate
    func composeChildViewArchitecture() {
        let factory = PresenterFactory()
        factory.createVideoCapturePresenter(parentView: view as! CommandOutputViewController)
    }

    // MARK: Start commands
    func startCommands() {
        updatingTimer = Timer.scheduledTimer(
            timeInterval: AppSettingModel.shared.messageInterval,
            target: self,
            selector: #selector(self.monitorCommands),
            userInfo: nil,
            repeats: true)

        mediator.startActiveCommands()
        ServiceManager.shared.send()
        updateOutput()

        let settings = AppSettingModel.shared.getSettingsForOutput()
        view.updateSettings(with: settings)
    }

    // MARK: Monitor commands
    @objc private func monitorCommands() {
        mediator.monitorManualCommands()
        ServiceManager.shared.send()
        updateOutput()
    }
    
    
    // MARK: Stop commands
    func stopCommands() {
        guard let t = updatingTimer else { return }
        if t.isValid {
            t.invalidate()
        }

        mediator.stopActiveCommands()
    }

    func isCameraUsed() -> Bool {
        return AppSettingModel.shared.isCameraUsed()
    }

    func isTouchEnabled() -> Bool {
        return AppSettingModel.shared.isTouchEnabled()
    }

    // MARK: Methods used in multiple timings

    private func updateOutput() {
        view.updateOutput(with: ServiceManager.shared.getLog(), errorLog: ServiceManager.shared.getErrorLog())
    }
}
