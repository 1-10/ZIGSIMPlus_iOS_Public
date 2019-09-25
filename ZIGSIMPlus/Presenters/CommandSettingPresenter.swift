//
//  CommandSettingPresenter.swift
//  ZIGSIMPlus
//
//  Created by YoneyamaShunpei on 2019/05/28.
//  Copyright © 2019 1→10, Inc. All rights reserved.
//

import Foundation
import SwiftyUserDefaults

public enum TextFieldName {
    case ipAdress
    case portNumber
    case uuid
}

public enum SegmentName {
    case dataDestination
    case dataProtocol
    case messageFormat
    case messageRatePerSecond
}

protocol CommandSettingPresenterProtocol {
    func getUserDefaultTexts() -> [TextFieldName: String]
    func getUserDefaultSegments() -> [SegmentName: Int]
    func updateTextsUserDefault(texts: [TextFieldName: String])
    func updateSegmentsUserDefault(segmentControls: [SegmentName: Int])
}

protocol CommandSettingPresenterDelegate: AnyObject {}

final class CommandSettingPresenter: CommandSettingPresenterProtocol {
    private weak var view: CommandSettingPresenterDelegate!

    init(view: CommandSettingPresenterDelegate) {
        self.view = view
    }

    func getUserDefaultTexts() -> [TextFieldName: String] {
        var texts: [TextFieldName: String] = [:]
        let appSettings = AppSettingModel.shared
        texts[.ipAdress] = appSettings.ipAddress
        texts[.portNumber] = appSettings.portNumber.description
        texts[.uuid] = appSettings.deviceUUID
        return texts
    }

    func getUserDefaultSegments() -> [SegmentName: Int] {
        var segments: [SegmentName: Int] = [:]
        let appSettings = AppSettingModel.shared
        segments[.dataDestination] = appSettings.dataDestination.rawValue
        segments[.dataProtocol] = appSettings.transportProtocol.rawValue
        segments[.messageFormat] = appSettings.transportFormat.rawValue
        segments[.messageRatePerSecond] = appSettings.messageRatePerSecond.rawValue

        return segments
    }

    func updateTextsUserDefault(texts: [TextFieldName: String]) {
        let appSettings = AppSettingModel.shared
        appSettings.ipAddress = texts[.ipAdress] ?? ""
        appSettings.portNumber = Int(texts[.portNumber] ?? "0") ?? 0
        appSettings.deviceUUID = texts[.uuid] ?? ""
    }

    func updateSegmentsUserDefault(segmentControls: [SegmentName: Int]) {
        let appSettings = AppSettingModel.shared
        appSettings.dataDestination = DataDestination(rawValue: segmentControls[.dataDestination] ?? 0)!
        appSettings.transportProtocol = TransportProtocol(rawValue: segmentControls[.dataProtocol] ?? 0)!
        appSettings.transportFormat = TransportFormat(rawValue: segmentControls[.messageFormat] ?? 0)!
        appSettings.messageRatePerSecond = RatePerSecond(rawValue: segmentControls[.messageRatePerSecond] ?? 0)!
    }
}
