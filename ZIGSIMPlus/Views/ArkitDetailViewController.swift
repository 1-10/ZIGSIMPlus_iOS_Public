//
//  ArkitDetailViewController.swift
//  ZIGSIMPlus
//
//  Created by Takayosi Amagi on 2019/06/17.
//  Copyright © 2019 Nozomu Kuwae. All rights reserved.
//

import Foundation
import UIKit
import SwiftyUserDefaults

public class ArkitDetailViewController : UIViewController {

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
            case .segmented(let data):
                let label = UILabel()
                label.text = data.label
                stackView.addArrangedSubview(label)

                let segmented = UISegmentedControl()
                for (j, segment) in data.segments.enumerated() {
                    segmented.insertSegment(withTitle: segment, at: j, animated: true)
                    segmented.setWidth(CGFloat(data.width / data.segments.count), forSegmentAt: j)
                }
                segmented.selectedSegmentIndex = data.value
                segmented.tag = i
                segmented.addTarget(self, action: #selector(segmentedAction(segmented:)), for: .valueChanged)
                stackView.addArrangedSubview(segmented)
            }
        }

        stackView.bounds = CGRect(x: 0, y: 0, width: 300, height: CGFloat(settings.count) * 60.0)
    }

    @objc func segmentedAction(segmented: UISegmentedControl) {
        let ds = presenter.getCommandDetailSettings()
        guard let settings = ds[command] else { return }
        guard case var .segmented(setting) = settings[segmented.tag] else { return }

        setting.value = segmented.selectedSegmentIndex        
        presenter.updateSetting(setting: .segmented(setting))
    }
}
