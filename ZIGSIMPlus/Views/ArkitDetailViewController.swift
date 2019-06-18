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

    @IBOutlet weak var stackView: UIStackView!

    override public func viewDidLoad() {
        super.viewDidLoad()

        let ds = AppSettingModel.shared.getCommandDetailSettings()
        guard let settings = ds[.arkit] else { return }

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

        stackView.heightAnchor.constraint(equalToConstant: CGFloat(settings.count) * 60.0)
    }

    @objc func segmentedAction(segmented: UISegmentedControl) {
        let ds = AppSettingModel.shared.getCommandDetailSettings()
        guard let settings = ds[.arkit] else { return }
        let setting = settings[segmented.tag]

        let value = segmented.selectedSegmentIndex

        switch setting {
        case .segmented(let data):
            switch data.key {
            case .arkitTrackingType:
                // TODO: Move UserDefault update to AppSettingModel?
                AppSettingModel.shared.arkitTrackingType = ArkitTrackingType(rawValue: value)!
                Defaults[.userArkitTrackingType] = value
            }
        }
    }
}
