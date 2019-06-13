//
//  NdiDetailPresenter.swift
//  ZIGSIMPlus
//
//  Created by YoneyamaShunpei on 2019/06/12.
//  Copyright © 2019 Nozomu Kuwae. All rights reserved.
//

import Foundation
import SwiftyUserDefaults

public enum NdiSegments {
    case NDI_TYPE
    case NDI_CAMERA_TYPE
    case DEPTH_TYPE
}

protocol NdiDetailPresenterProtocol {
    func getUserDefault() -> Dictionary<NdiSegments,Int>
    func updateNdiTypeUserDefault(selectIndex: Int)
    func updateNdiCameraTypeUserDefault(selectIndex: Int)
    func updateDepthTypeUserDefault(selectIndex: Int)
}

final class NdiDetailPresenter: NdiDetailPresenterProtocol {
    func getUserDefault() -> Dictionary<NdiSegments, Int> {
        let segments:[NdiSegments: Int] = [
            .NDI_TYPE : Defaults[.userNdiType] ?? 0,
            .NDI_CAMERA_TYPE : Defaults[.userNdiCameraType] ?? 0,
            .DEPTH_TYPE : Defaults[.userDepthType] ?? 0
        ]
        return segments
    }
    
    func updateNdiTypeUserDefault(selectIndex: Int) {
        AppSettingModel.shared.ndiType = NdiType(rawValue: selectIndex)!
        Defaults[.userNdiType] = AppSettingModel.shared.ndiType.rawValue
    }
    
    func updateNdiCameraTypeUserDefault(selectIndex: Int) {
        AppSettingModel.shared.ndiCameraType = NdiCameraType(rawValue: selectIndex)!
        Defaults[.userNdiCameraType] = AppSettingModel.shared.ndiCameraType.rawValue
    }
    
    func updateDepthTypeUserDefault(selectIndex: Int) {
        AppSettingModel.shared.depthType = DepthType(rawValue: selectIndex)!
        Defaults[.userDepthType] = AppSettingModel.shared.depthType.rawValue
    }
}
