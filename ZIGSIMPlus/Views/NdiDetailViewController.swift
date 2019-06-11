//
//  NdiDetailViewController.swift
//  ZIGSIMPlus
//
//  Created by YoneyamaShunpei on 2019/06/06.
//  Copyright © 2019 Nozomu Kuwae. All rights reserved.
//

import Foundation
import UIKit
import SwiftyUserDefaults

public class NdiDetailViewController : UIViewController {
    
    @IBOutlet weak var segmentLabel: UILabel!
    @IBOutlet var segments: [UISegmentedControl]!
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        for segment in segments {
            if segment.tag == 0 {
                segment.selectedSegmentIndex = Int(Defaults[.userNdiType]?.description ?? "0") ?? 0
            } else if segment.tag == 1 {
                segment.selectedSegmentIndex = Int(Defaults[.userNdiCameraType]?.description ?? "0") ?? 0
            } else if segment.tag == 2 {
                segment.selectedSegmentIndex = Int(Defaults[.userDepthType]?.description ?? "0") ?? 0
            }
        }
    }
    
    @IBAction func segmentAction(_ sender: UISegmentedControl) {
        if sender.tag == 0 { // CAMERA or DEPTH
            if sender.selectedSegmentIndex == 0 {
                AppSettingModel.shared.ndiType = .CAMERA
            } else if sender.selectedSegmentIndex == 1 {
                AppSettingModel.shared.ndiType = .DEPTH
            }
            Defaults[.userNdiType] = AppSettingModel.shared.ndiType.rawValue
        } else if sender.tag == 1 { // OUTCAMERA or INCAMERA
            if sender.selectedSegmentIndex == 0 {
                AppSettingModel.shared.ndiCameraType = .BACK
            } else if sender.selectedSegmentIndex == 1 {
                AppSettingModel.shared.ndiCameraType = .FRONT
            }
            Defaults[.userNdiCameraType] = AppSettingModel.shared.ndiCameraType.rawValue
        } else if sender.tag == 2 { // DEPTH or DISPARITY
            if sender.selectedSegmentIndex == 0 {
                AppSettingModel.shared.depthType = .DEPTH
            } else if sender.selectedSegmentIndex == 1 {
                AppSettingModel.shared.depthType = .DISPARITY
            }
            Defaults[.userDepthType] = AppSettingModel.shared.depthType.rawValue
        }
    }
}
