//
//  CommandDetailSettingsViewController.swift
//  ZIGSIMPlus
//
//  Created by Takayosi Amagi on 2019/06/17.
//  Copyright © 2019 Nozomu Kuwae. All rights reserved.
//

import Foundation
import UIKit

let mainColor = UIColor(displayP3Red: 2/255, green: 141/255, blue: 90/255, alpha: 1.0)

public class CommandDetailSettingsViewController : UIViewController {

    var presenter: CommandDetailSettingsPresenterProtocol!
    var command: Command!

    @IBOutlet weak var stackView: UIStackView!

    override public func viewDidLoad() {
        super.viewDidLoad()
        presenter = CommandDetailSettingsPresenter()

        let settings = presenter.getCommandDetailSettings()
        guard let settingsForCommand = settings[command] else { return }

        // Render inputs for settings
        for setting in settingsForCommand {
            switch setting {
            case let data as Segmented:
                let label = UILabel()
                label.text = data.label
                label.textColor = mainColor
                stackView.addArrangedSubview(label)

                let segmented = UISegmentedControl()
                for (i, segment) in data.segments.enumerated() {
                    segmented.insertSegment(withTitle: segment, at: i, animated: true)
                    segmented.setWidth(CGFloat(data.width / data.segments.count), forSegmentAt: i)
                }
                segmented.selectedSegmentIndex = data.value
                segmented.addTarget(self, action: #selector(segmentedAction(segmented:)), for: .valueChanged)
                segmented.tintColor = mainColor

                // Use DetailSettingKey for identifier
                segmented.tag = data.key.rawValue
                
                // We added this processing because check depth availability, set ndi type and depth type segment
                if !VideoCaptureService.shared.isDepthRearCameraAvailable() {
                    if DetailSettingsKey.ndiType == data.key {
                        segmented.selectedSegmentIndex = 0 // 0 is color. (This color is what enum variable of VideoCaptureService.swift)
                        segmented.isEnabled = false
                    } else if DetailSettingsKey.ndiDepthType == data.key {
                        segmented.isEnabled = false
                    }
                }
                // We added this processing because check front camera availability on depth , set camera type segment
                if !VideoCaptureService.shared.isDepthFrontCameraAvailable() && DetailSettingsKey.ndiCamera == data.key {
                    let segment = getSegment(tagNo: DetailSettingsKey.ndiType.rawValue)
                    if segment?.selectedSegmentIndex == 1 { // 1 is depth. (This front is what CameraType variable of VideoCaptureService.swift)
                        segmented.selectedSegmentIndex = 0  // 0 is front.
                        segmented.isEnabled = false
                    }
                }

                stackView.addArrangedSubview(segmented)
            default:
                break
            }
        }

        stackView.bounds = CGRect(x: 0, y: 0, width: 300, height: CGFloat(settingsForCommand.count) * 60.0)
    }

    @objc func segmentedAction(segmented: UISegmentedControl) {
        // Get settings for current command
        let settings = presenter.getCommandDetailSettings()
        guard let settingsForCommand = settings[command] else { return }

        // Find setting by DetailSettingKey
        guard var setting = settingsForCommand.first(where: {
            if let s = $0 as? Segmented {
                return s.key.rawValue == segmented.tag
            }
            return false
        }) as? Segmented else { return }

        // We added this processing because let rear camera used when device can not use the front camere on Depth
        if DetailSettingsKey.ndiType == setting.key {
            let segment = getSegment(tagNo: DetailSettingsKey.ndiCamera.rawValue)
            if !VideoCaptureService.shared.isDepthFrontCameraAvailable() && 1 == segmented.selectedSegmentIndex {
                segment?.selectedSegmentIndex = 0 // 0 is front.
                segment?.isEnabled = false
            } else {
                segment?.isEnabled = true
            }
        }
        
        // Pass updated setting to presenter
        setting.value = segmented.selectedSegmentIndex
        presenter.updateSetting(setting: setting)
    }
    
    private func getSegment(tagNo:Int) -> UISegmentedControl? {
        var segment: UISegmentedControl?
        for stackView in stackView.arrangedSubviews {
            if UISegmentedControl.self == type(of: stackView) {
                if stackView.tag == tagNo {
                  segment = stackView as? UISegmentedControl
                  break
                }
            }
        }
        return segment
    }
}
