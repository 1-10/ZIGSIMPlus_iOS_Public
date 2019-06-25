//
//  CommandDetailSettingsViewController.swift
//  ZIGSIMPlus
//
//  Created by Takayosi Amagi on 2019/06/17.
//  Copyright © 2019 Nozomu Kuwae. All rights reserved.
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
                let label = UILabel()
                label.text = data.label
                label.textColor = Theme.main
                stackView.addArrangedSubview(label)

                let segmented = UISegmentedControl()
                for (i, segment) in data.segments.enumerated() {
                    segmented.insertSegment(withTitle: segment, at: i, animated: true)
                    segmented.setWidth(CGFloat(data.width / data.segments.count), forSegmentAt: i)
                }
                segmented.selectedSegmentIndex = data.value
                segmented.addTarget(self, action: #selector(segmentedAction(segmented:)), for: .valueChanged)
                segmented.tintColor = Theme.main

                // Use DetailSettingKey for identifier
                segmented.tag = data.key.rawValue

                stackView.addArrangedSubview(segmented)

            case let data as UUIDInput:
                let label = UILabel()
                label.text = data.label
                label.textColor = Theme.main
                stackView.addArrangedSubview(label)

                let input = UITextField()
                input.text = data.value

                input.textColor = Theme.main
                input.backgroundColor = Theme.black
                input.layer.borderColor = Theme.main.cgColor
                input.layer.borderWidth = 1
                input.layer.cornerRadius = 4
                input.borderStyle = .roundedRect
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

        stackView.bounds = CGRect(x: 0, y: 0, width: 300, height: CGFloat(settingsForCommand.count) * 60.0)
    }

    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
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

        // Pass updated setting to presenter
        setting.value = segmented.selectedSegmentIndex
        presenter.updateSetting(setting: setting)
    }

    @objc func uuidInputAction(input: UITextField) {
        // Format input
        guard var text = input.text else { return }
        text = text.uppercased()

        // Insert hyphens
        [8, 13, 18, 23].forEach { i in
            if text.count > i {
                let idx = text.index(text.startIndex, offsetBy: i)
                if text[idx] != "-" {
                    text.insert("-", at: idx)
                }
            }
        }

        // Limit length
        if text.count > 36 {
            let idx = text.index(text.startIndex, offsetBy: 36)
            text = String(text[..<idx])
        }

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
}
