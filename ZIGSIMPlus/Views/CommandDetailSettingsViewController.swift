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
                
                setSegmentedAvailability(key: data.key, segmented)
                
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

        setSegmentedAvailability(key: setting.key, segmented)
        
        // Pass updated setting to presenter
        setting.value = segmented.selectedSegmentIndex
        presenter.updateSetting(setting: setting)
    }
    
    private func setSegmentedAvailability(key: DetailSettingsKey, _ segmented: UISegmentedControl) {
        switch key {
        case .ndiType:
            if !VideoCaptureService.shared.isDepthRearCameraAvailable() {
                segmented.selectedSegmentIndex = 0
                segmented.isEnabled = false
            }
            
            let getedSegmented = getSegmented(segmented: DetailSettingsKey.ndiCamera.rawValue)
            if !VideoCaptureService.shared.isDepthFrontCameraAvailable() && 1 == segmented.selectedSegmentIndex {
                getedSegmented?.selectedSegmentIndex = 0
                getedSegmented?.isEnabled = false
            } else {
                getedSegmented?.isEnabled = true
            }
        case .ndiCamera:
            if !VideoCaptureService.shared.isDepthFrontCameraAvailable(){
                let getedSegmented = getSegmented(segmented: DetailSettingsKey.ndiType.rawValue)
                if getedSegmented?.selectedSegmentIndex == 1 {
                    segmented.selectedSegmentIndex = 0
                    segmented.isEnabled = false
                } else {
                    segmented.isEnabled = true
                }
            }
        case .ndiDepthType:
            if !VideoCaptureService.shared.isDepthRearCameraAvailable() {
                segmented.isEnabled = false
            }
        default :
            return
        }
        
    }
    
    private func getSegmented(segmented:Int) -> UISegmentedControl? {
        var segment: UISegmentedControl?
        for stackView in stackView.arrangedSubviews {
            if UISegmentedControl.self == type(of: stackView) {
                if stackView.tag == segmented {
                  segment = stackView as? UISegmentedControl
                  break
                }
            }
        }
        return segment
    }
}
