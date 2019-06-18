//
//  CommandDetailSettingsViewController.swift
//  ZIGSIMPlus
//
//  Created by Takayosi Amagi on 2019/06/17.
//  Copyright © 2019 Nozomu Kuwae. All rights reserved.
//

import Foundation
import UIKit
import SwiftyUserDefaults

public class CommandDetailSettingsViewController : UIViewController {

    var presenter: CommandDetailSettingsPresenterProtocol!
    var command: Command!

    @IBOutlet weak var stackView: UIStackView!

    override public func viewDidLoad() {
        super.viewDidLoad()
        presenter = CommandDetailSettingsPresenter()

        let ds = presenter.getCommandDetailSettings()
        guard let settings = ds[command] else { return }

        // Render inputs for settings
        for (i, setting) in settings.enumerated() {
            switch setting {
            case let data as Selector:
                let label = UILabel()
                label.text = data.label
                stackView.addArrangedSubview(label)

                let selector = UISegmentedControl()
                for (j, segment) in data.segments.enumerated() {
                    selector.insertSegment(withTitle: segment, at: j, animated: true)
                    selector.setWidth(CGFloat(data.width / data.segments.count), forSegmentAt: j)
                }
                selector.selectedSegmentIndex = data.value
                selector.tag = i
                selector.addTarget(self, action: #selector(selectorAction(selector:)), for: .valueChanged)
                stackView.addArrangedSubview(selector)
            default:
                break
            }
        }

        stackView.bounds = CGRect(x: 0, y: 0, width: 300, height: CGFloat(settings.count) * 60.0)
    }

    @objc func selectorAction(selector: UISegmentedControl) {
        let ds = presenter.getCommandDetailSettings()
        guard let settings = ds[command] else { return }
        guard case var setting as Selector = settings[selector.tag] else { return }

        setting.value = selector.selectedSegmentIndex
        presenter.updateSetting(setting: setting)
    }
}
