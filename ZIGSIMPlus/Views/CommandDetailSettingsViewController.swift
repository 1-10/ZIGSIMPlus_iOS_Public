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
                
                if let dataInt = data as? SegmentedInt {
                    segmented.selectedSegmentIndex = dataInt.value
                } else if let dataBool = data as? SegmentedBool {
                    segmented.selectedSegmentIndex = (dataBool.value ? 0 : 1)
                }
                
                segmented.addTarget(self, action: #selector(segmentedAction(segmented:)), for: .valueChanged)
                segmented.tintColor = Theme.main

                // Use DetailSettingKey for identifier
                segmented.tag = data.key.rawValue

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
        guard let setting: DetailSetting = settingsForCommand.first(where: {
            if let s = $0 as? Segmented {
                return s.key.rawValue == segmented.tag
            }
            return false
        }) else { return }

        // Pass updated setting to presenter
        if var segmentedInt = setting as? SegmentedInt {
            segmentedInt.value = segmented.selectedSegmentIndex
            presenter.updateSetting(setting: segmentedInt)
        } else if var segmentedBool = setting as? SegmentedBool {
            segmentedBool.value = (segmented.selectedSegmentIndex == 0 ? true : false)
            presenter.updateSetting(setting: segmentedBool)
        }
    }
}
