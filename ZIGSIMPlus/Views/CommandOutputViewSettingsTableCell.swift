//
//  CommandOutputViewSettingsTableCell.swift
//  ZIGSIMPlus
//
//  Created by Takayosi Amagi on 2019/06/07.
//  Copyright © 2019 1→10, Inc. All rights reserved.
//

import Foundation
import UIKit

class CommandOutputViewSettingsTableCell: UITableViewCell {
    @IBOutlet weak var settingKeyLabel: UILabel!
    @IBOutlet weak var settingValueLabel: UILabel!

    public func setKeyValue(_ key: String?, _ value: String?) {
        settingKeyLabel.text = " \(key ?? "")" // add padding
        settingValueLabel.text = value
    }
}
