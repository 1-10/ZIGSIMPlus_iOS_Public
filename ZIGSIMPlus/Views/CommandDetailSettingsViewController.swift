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

            case let data as TextInput:
                let label = UILabel()
                label.text = data.label
                label.textColor = Theme.main
                stackView.addArrangedSubview(label)

                let input = UITextField()
                input.text = data.value
                input.addTarget(self, action: #selector(textInputAction(input:)), for: .editingChanged)

                input.textColor = Theme.main
                input.backgroundColor = Theme.black
                input.layer.borderColor = Theme.main.cgColor
                input.layer.borderWidth = 1
                input.layer.cornerRadius = 4
                input.borderStyle = .roundedRect
                input.addConstraint(NSLayoutConstraint(item: input, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: CGFloat(data.width)))

                // Use DetailSettingKey for identifier
                input.tag = data.key.rawValue

                stackView.addArrangedSubview(input)

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

        // Pass updated setting to presenter
        setting.value = segmented.selectedSegmentIndex
        presenter.updateSetting(setting: setting)
    }

    @objc func textInputAction(input: UITextField) {
        // Get settings for current command
        let settings = presenter.getCommandDetailSettings()
        guard let settingsForCommand = settings[command] else { return }

        // Find setting by DetailSettingKey
        guard var setting = settingsForCommand.first(where: {
            if let s = $0 as? TextInput {
                return s.key.rawValue == input.tag
            }
            return false
        }) as? TextInput else { return }

        // Pass updated setting to presenter
        setting.value = input.text ?? ""
        presenter.updateSetting(setting: setting)
    }
}
