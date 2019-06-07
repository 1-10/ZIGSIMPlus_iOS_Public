//
//  StandardCell.swift
//  ZIGSIMPlus
//
//  Created by YoneyamaShunpei on 2019/06/06.
//  Copyright © 2019 Nozomu Kuwae. All rights reserved.
//

import Foundation
import UIKit

public class StandardCell: UITableViewCell {
   
    @IBOutlet weak var commandOnOff: UISwitch!
    @IBOutlet weak var commandLabel: UILabel!
    @IBOutlet weak var settingButton: UIButton!
    @IBOutlet weak var modalButton: UIButton!
    
    var commandSelectionPresenter: CommandSelectionPresenterProtocol!
    var tableview: UITableView!
    var viewController: UIViewController!
    var backButtonLabel: UIButton!
    var commandsLabel:[Int: Command]!
    
    @IBAction func commandOnOffAction(_ sender: UISwitch) {
        commandSelectionPresenter.didSelectRow(atLabel: commandsLabel[sender.tag]!.rawValue)
    }
    
    @IBAction func settingButtonAction(_ sender: UIButton) {
        tableview.isHidden = true
        backButtonLabel.isHidden = false
    }
    
    @IBAction func modalButtonAction(_ sender: UIButton) {
        
    }
    
    
}
