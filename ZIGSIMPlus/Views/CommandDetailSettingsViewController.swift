//
//  CommandDetailSettingsViewController.swift
//  ZIGSIMPlus
//
//  Created by Takayosi Amagi on 2019/06/17.
//  Copyright © 2019 1→10, Inc. All rights reserved.
//

import Foundation
import UIKit

public class CommandDetailSettingsViewController: UIViewController {
    var presenter: CommandDetailSettingsPresenterProtocol!
    var command: Command!

    @IBOutlet var stackView: UIStackView!

    public override func viewDidLoad() {
        super.viewDidLoad()
        presenter = CommandDetailSettingsPresenter()

        let settings = presenter.getCommandDetailSettings()
        guard let settingsForCommand = settings[command] else { return }

        // Render inputs for settings
        for setting in settingsForCommand {
            switch setting {
            case let data as Segmented:
                renderSegmented(data)
            case let data as UUIDInput:
                renderUUIDInput(data)
            default:
                break
            }
        }

        // Because the specification of UISegmentedControl has changed from iOS13
        if #available(iOS 13.0, *) {
            stackView.bounds = CGRect(x: 0, y: 0, width: 300, height: CGFloat(settingsForCommand.count) * 66.0)
        } else {
            stackView.bounds = CGRect(x: 0, y: 0, width: 300, height: CGFloat(settingsForCommand.count) * 64.0)
        }

        // set height of stack view
        stackView.constraints.first?.constant = CGFloat(80 * settingsForCommand.count)

        // only ndi detail view
        setActivityOfDependingOnNdiSceneType()
    }

    public override func touchesBegan(_: Set<UITouch>, with _: UIEvent?) {
        view.endEditing(true)
    }

    @objc func segmentedAction(segmented: UISegmentedControl) {
        // only ndi detail view
        setActivityOfDependingOnNdiSceneType()

        // Get settings for current command
        let settings = presenter.getCommandDetailSettings()
        guard let settingsForCommand = settings[command] else { return }

        // Find setting by DetailSettingKey
        guard let setting: DetailSetting = settingsForCommand.first(where: {
            if let seg = $0 as? Segmented {
                return seg.key.rawValue == segmented.tag
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
            if let s = $0 as? UUIDInput { // swiftlint:disable:this identifier_name
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
        case .ndiWorldType:
            setActivityOfDependingOnNdiWorldType(segmentedControl: segmented)
        case .ndiCamera:
            setActivityOfDependingOnNdiCameraType(segmentedControl: segmented)
        case .ndiDepthType:
            setActivityOfDependingOnNdiDepthType(segmentedControl: segmented)
        case .arkitTrackingType:
            if !ArkitService.shared.isBodyTrackingAvailable() {
                segmented.removeSegment(at: 3, animated: false)
            }
        default:
            return
        }
    }

    private func renderSegmented(_ data: Segmented) {
        let label = ZIGLabel()
        label.text = data.label
        stackView.addArrangedSubview(label)

        let segmented = ZIGSegmentedControl()
        for (i, segment) in data.segments.enumerated() {
            segmented.insertSegment(withTitle: segment, at: i, animated: true)
            segmented.setWidth(CGFloat(data.width / data.segments.count), forSegmentAt: i)

            // Because the specification of UISegmentedControl has changed from iOS13
            if #available(iOS 13.0, *) {
                segmented.selectedSegmentTintColor = Theme.main
                segmented.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: Theme.main], for: .normal)
                segmented.layer.borderWidth = 1
                segmented.layer.borderColor = Theme.main.cgColor
            }
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
    }

    private func renderUUIDInput(_ data: UUIDInput) {
        let label = ZIGLabel()
        label.text = data.label
        stackView.addArrangedSubview(label)

        let input = ZIGTextField()
        input.text = data.value
        input.addConstraint(NSLayoutConstraint(
            item: input,
            attribute: .width,
            relatedBy: .equal,
            toItem: nil,
            attribute: .notAnAttribute,
            multiplier: 1,
            constant: CGFloat(data.width)
        ))

        input.addTarget(self, action: #selector(uuidInputAction(input:)), for: .allEditingEvents)
        input.autocapitalizationType = .allCharacters

        // Use DetailSettingKey for identifier
        input.tag = data.key.rawValue

        stackView.addArrangedSubview(input)
    }

    private func getSegmented(tagNo: Int) -> UISegmentedControl? {
        var segmented: UISegmentedControl?
        for stackView in stackView.arrangedSubviews {
            if ZIGSegmentedControl.self == type(of: stackView) {
                if stackView.tag == tagNo {
                    segmented = stackView as? UISegmentedControl
                    break
                }
            }
        }
        return segmented
    }

    private func setActivityOfDependingOnNdiWorldType(segmentedControl: UISegmentedControl) {
        if !VideoCaptureService.shared.isDepthRearCameraAvailable() {
            segmentedControl.selectedSegmentIndex = 0
            segmentedControl.isEnabled = false
        }

        let segmentedForNdiCamera = getSegmented(tagNo: DetailSettingsKey.ndiCamera.rawValue)
        if !VideoCaptureService.shared.isDepthFrontCameraAvailable(), segmentedControl.selectedSegmentIndex == 1 {
            segmentedForNdiCamera?.selectedSegmentIndex = 0
            AppSettingModel.shared.ndiCameraPosition = .BACK
            segmentedForNdiCamera?.isEnabled = false
        } else {
            segmentedForNdiCamera?.isEnabled = true
        }
    }

    private func setActivityOfDependingOnNdiCameraType(segmentedControl: UISegmentedControl) {
        if !VideoCaptureService.shared.isDepthFrontCameraAvailable() {
            let segmentedForNdiWorldType = getSegmented(tagNo: DetailSettingsKey.ndiWorldType.rawValue)
            if segmentedForNdiWorldType?.selectedSegmentIndex == 1 {
                segmentedControl.selectedSegmentIndex = 0
                AppSettingModel.shared.ndiCameraPosition = .BACK
                segmentedControl.isEnabled = false
            } else {
                segmentedControl.isEnabled = true
            }
        }
    }

    private func setActivityOfDependingOnNdiDepthType(segmentedControl: UISegmentedControl) {
        if !VideoCaptureService.shared.isDepthRearCameraAvailable() {
            segmentedControl.isEnabled = false
        }
    }

    private func setActivityOfDependingOnNdiSceneType() {
        let segmentedForNdiSceneType = getSegmented(tagNo: DetailSettingsKey.ndiSceneType.rawValue)
        if !VideoCaptureService.shared.isHumanSegmentationAvailable() {
            segmentedForNdiSceneType?.selectedSegmentIndex = 0
            AppSettingModel.shared.ndiSceneType = .WORLD
            segmentedForNdiSceneType?.isEnabled = false
        } else {
            getSegmented(tagNo: DetailSettingsKey.ndiWorldType.rawValue)?.isEnabled = true
            getSegmented(tagNo: DetailSettingsKey.ndiCamera.rawValue)?.isEnabled = true
            getSegmented(tagNo: DetailSettingsKey.ndiDepthType.rawValue)?.isEnabled = true
            getSegmented(tagNo: DetailSettingsKey.ndiHumanType.rawValue)?.isEnabled = true

            if segmentedForNdiSceneType?.selectedSegmentIndex == NdiSceneType.WORLD.rawValue {
                if let ndiWorldSegmented = getSegmented(tagNo: DetailSettingsKey.ndiWorldType.rawValue) {
                    setActivityOfDependingOnNdiWorldType(segmentedControl: ndiWorldSegmented)
                }
                if let ndiCameraSegmented = getSegmented(tagNo: DetailSettingsKey.ndiCamera.rawValue) {
                    setActivityOfDependingOnNdiCameraType(segmentedControl: ndiCameraSegmented)
                }
                if let ndiDepthTypeSegmented = getSegmented(tagNo: DetailSettingsKey.ndiDepthType.rawValue) {
                    setActivityOfDependingOnNdiDepthType(segmentedControl: ndiDepthTypeSegmented)
                }
                getSegmented(tagNo: DetailSettingsKey.ndiHumanType.rawValue)?.isEnabled = false
            } else if segmentedForNdiSceneType?.selectedSegmentIndex == NdiSceneType.HUMAN.rawValue {
                getSegmented(tagNo: DetailSettingsKey.ndiWorldType.rawValue)?.isEnabled = false
                getSegmented(tagNo: DetailSettingsKey.ndiDepthType.rawValue)?.isEnabled = false
            }
        }
    }
}
