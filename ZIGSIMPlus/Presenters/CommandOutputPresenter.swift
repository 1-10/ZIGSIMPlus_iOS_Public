//
//  CommandOutputPresenter.swift
//  ZIGSIMPlus
//
//  Created by Nozomu Kuwae on 5/10/19.
//  Copyright © 2019 1→10, Inc. All rights reserved.
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
    func updateOutput(with log: String, errorLog: String?)
    func updateSettings(with settings: [(String, String)])
}

final class CommandOutputPresenter: CommandOutputPresenterProtocol {
    private weak var view: CommandOutputPresenterDelegate!

    init(view: CommandOutputPresenterDelegate) {
        self.view = view

        CommandPlayer.shared.onUpdate = {
            self.updateOutput()
        }
    }

    // This cannnot be defined in AppDelegate, because subviews cannot be accessed from AppDelegate
    // https://stackoverflow.com/questions/50780404/swift-how-to-reference-subview-from-appdelegate
    func composeChildViewArchitecture() {
        let factory = PresenterFactory()
        // swiftlint:disable:next force_cast
        factory.createVideoCapturePresenter(parentView: view as! CommandOutputViewController)
    }

    func startCommands() {
        CommandPlayer.shared.play()
        view.updateSettings(with: AppSettingModel.shared.getSettingsForOutput())
    }

    func stopCommands() {
        CommandPlayer.shared.stop()
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
