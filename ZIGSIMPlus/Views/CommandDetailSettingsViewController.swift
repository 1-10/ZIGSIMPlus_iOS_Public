//
//  CommandDetailSettingsViewController.swift
//  ZIGSIMPlus
//
//  Created by Takayosi Amagi on 2019/06/17.
//  Copyright © 2019 1→10, Inc. All rights reserved.
//

import Foundation
import UIKit

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
                let label = ZIGLabel()
                label.text = data.label
                stackView.addArrangedSubview(label)

                let segmented = ZIGSegmentedControl()
                for (i, segment) in data.segments.enumerated() {
                    segmented.insertSegment(withTitle: segment, at: i, animated: true)
                    segmented.setWidth(CGFloat(data.width / data.segments.count), forSegmentAt: i)
                }
                
                if let dataInt = data as? SegmentedInt {
                    segmented.selectedSegmentIndex = dataInt.value
                } else if let dataBool = data as? SegmentedBool {
                    segmented.selectedSegmentIndex = (dataBool.value ? 0 : 1)
                }
                
                segmented.addTarget(self, action: #selector(segmentedAction(segmented:)), for: .valueChanged)

                // Use DetailSettingKey for identifier
                segmented.tag = data.key.rawValue
                
                setSegmentedAvailablity(settingKey: data.key, segmented)
                
                stackView.addArrangedSubview(segmented)

            case let data as UUIDInput:
                let label = ZIGLabel()
                label.text = data.label
                stackView.addArrangedSubview(label)

                let input = ZIGTextField()
                input.text = data.value
                input.addConstraint(NSLayoutConstraint(item: input, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: CGFloat(data.width)))

                input.addTarget(self, action: #selector(uuidInputAction(input:)), for: .allEditingEvents)
                input.autocapitalizationType = .allCharacters

                // Use DetailSettingKey for identifier
                input.tag = data.key.rawValue

                stackView.addArrangedSubview(input)

            default:
                break
            }
        }

        stackView.bounds = CGRect(x: 0, y: 0, width: 300, height: CGFloat(settingsForCommand.count) * 64.0)
    }

    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    @objc func segmentedAction(segmented: UISegmentedControl) {
        // Get settings for current command
        let settings = presenter.getCommandDetailSettings()
        guard let settingsForCommand = settings[command] else { return }

        // Find setting by DetailSettingKey
        guard let setting: DetailSetting = settingsForCommand.first(where: {
            if let s = $0 as? Segmented {
                return s.key.rawValue == segmented.tag
            }
            return false
        }) else { return }
        
        
        // Pass updated setting to presenter
        if var segmentedInt = setting as? SegmentedInt {
            setSegmentedAvailablity(settingKey: segmentedInt.key, segmented)
            segmentedInt.value = segmented.selectedSegmentIndex
            presenter.updateSetting(setting: segmentedInt)
        } else if var segmentedBool = setting as? SegmentedBool {
            segmentedBool.value = (segmented.selectedSegmentIndex == 0 ? true : false)
            presenter.updateSetting(setting: segmentedBool)
        }
    }

    @objc func uuidInputAction(input: UITextField) {
        var text = input.text ?? ""

        // Format input
        text = Utils.formatBeaconUUID(text)
        input.text = text

        // Validate input
        if !Utils.isValidBeaconUUID(text) {
            input.layer.borderColor = Theme.error.cgColor
            return
        }
        input.layer.borderColor = Theme.main.cgColor

        // Get settings for current command
        let settings = presenter.getCommandDetailSettings()
        guard let settingsForCommand = settings[command] else { return }

        // Find setting by DetailSettingKey
        guard var setting = settingsForCommand.first(where: {
            if let s = $0 as? UUIDInput {
                return s.key.rawValue == input.tag
            }
            return false
        }) as? UUIDInput else { return }
        
        // Pass updated setting to presenter
        setting.value = text
        presenter.updateSetting(setting: setting)
    }
    
    private func setSegmentedAvailablity(settingKey: DetailSettingsKey, _ segmented: UISegmentedControl) {
        switch settingKey {
        case .ndiType:
            if !VideoCaptureService.shared.isDepthRearCameraAvailable() {
                segmented.selectedSegmentIndex = 0
                segmented.isEnabled = false
            }
            
            let segmentedForNdiCamera = getSegmented(tagNo: DetailSettingsKey.ndiCamera.rawValue)
            if !VideoCaptureService.shared.isDepthFrontCameraAvailable() && segmented.selectedSegmentIndex == 1  {
                segmentedForNdiCamera?.selectedSegmentIndex = 0
                AppSettingModel.shared.ndiCameraPosition = .BACK
                segmentedForNdiCamera?.isEnabled = false
            } else {
                segmentedForNdiCamera?.isEnabled = true
            }
        case .ndiCamera:
            if !VideoCaptureService.shared.isDepthFrontCameraAvailable(){
                let segmentedForNdiType = getSegmented(tagNo: DetailSettingsKey.ndiType.rawValue)
                if segmentedForNdiType?.selectedSegmentIndex == 1 {
                    segmented.selectedSegmentIndex = 0
                    AppSettingModel.shared.ndiCameraPosition = .BACK
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
    
    private func getSegmented(tagNo :Int) -> UISegmentedControl? {
        var segmented: UISegmentedControl?
        for stackView in stackView.arrangedSubviews {
            if ZIGSegmentedControl.self == type(of: stackView) {
                if stackView.tag ==  tagNo {
                  segmented = stackView as? UISegmentedControl
                  break
                }
            }
        }
        return segmented
    }
}
