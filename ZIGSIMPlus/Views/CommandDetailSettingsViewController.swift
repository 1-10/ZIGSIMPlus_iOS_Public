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
            case let data as Selector:
                let label = UILabel()
                label.text = data.label
                stackView.addArrangedSubview(label)

                let selector = UISegmentedControl()
                for (i, segment) in data.segments.enumerated() {
                    selector.insertSegment(withTitle: segment, at: i, animated: true)
                    selector.setWidth(CGFloat(data.width / data.segments.count), forSegmentAt: i)
                }
                selector.selectedSegmentIndex = data.value
                selector.addTarget(self, action: #selector(selectorAction(selector:)), for: .valueChanged)

                // Use DetailSettingKey for selector identifier
                selector.tag = data.key.rawValue

                stackView.addArrangedSubview(selector)
            default:
                break
            }
        }

        stackView.bounds = CGRect(x: 0, y: 0, width: 300, height: CGFloat(settingsForCommand.count) * 60.0)
    }

    @objc func selectorAction(selector: UISegmentedControl) {
        // Get settings for current command
        let settings = presenter.getCommandDetailSettings()
        guard let settingsForCommand = settings[command] else { return }

        // Find setting by DetailSettingKey
        guard var setting = settingsForCommand.first(where: {
            if let s = $0 as? Selector {
                return s.key.rawValue == selector.tag
            }
            return false
        }) as? Selector else { return }

        // Pass updated setting to presenter
        setting.value = selector.selectedSegmentIndex
        presenter.updateSetting(setting: setting)
    }
}
