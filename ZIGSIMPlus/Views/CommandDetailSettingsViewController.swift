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
    var selectedSegmented: UISegmentedControl!

    @IBOutlet var stackView: UIStackView!

    public override func viewDidLoad() {
        super.viewDidLoad()
        presenter = CommandDetailSettingsPresenter(view: self)

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
        presenter.setAvailabilityOfNdiSceneType()
    }

    public override func touchesBegan(_: Set<UITouch>, with _: UIEvent?) {
        view.endEditing(true)
    }

    @objc func segmentedAction(segmented: UISegmentedControl) {
        // only ndi detail view
        presenter.setAvailabilityOfNdiSceneType()

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

        selectedSegmented = segmented

        // Pass updated setting to presenter
        if var segmentedInt = setting as? SegmentedInt {
            presenter.didSelectedAndInitSegment(settingKey: segmentedInt.key)
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

        selectedSegmented = segmented
        presenter.didSelectedAndInitSegment(settingKey: data.key)

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

    internal func getSegmented(tagNo: Int) -> UISegmentedControl? {
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
}

extension CommandDetailSettingsViewController: CommandDetailSettingsPresenterDelegate {
    func setSelectedSegmentIndex(index: Int) {
        selectedSegmented.selectedSegmentIndex = index
    }

    func setSelectedSegmentActivity(isEnabled: Bool) {
        selectedSegmented.isEnabled = isEnabled
    }

    func getSegmentedIndexOf(tagNo: Int) -> Int? {
        return getSegmented(tagNo: tagNo)?.selectedSegmentIndex
    }

    func setSegmentedIndexOf(tagNo: Int, index: Int) {
        getSegmented(tagNo: tagNo)?.selectedSegmentIndex = index
    }

    func setSegmentActivityOf(tagNo: Int, isEnable: Bool) {
        getSegmented(tagNo: tagNo)?.isEnabled = isEnable
    }

    func getCurrentSegmentId() -> Int { selectedSegmented.selectedSegmentIndex }

    func setUnavailableBodyTracking() {
        selectedSegmented.removeSegment(at: 3, animated: false)
    }
}
