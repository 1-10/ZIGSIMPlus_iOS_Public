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
    @IBOutlet weak var detaileButton: UIButton!
    @IBOutlet weak var modalButton: UIButton!
    
    
    var commandSelectionPresenter: CommandSelectionPresenterProtocol!
    var tableview: UITableView!
    var ndiDetaileView: UIView!
    var compassDetaileView: UIView!
    var modalParentLabel: UILabel!
    var modalParentButton: UIButton!
    var viewController: UIViewController!
    var backButtonLabel: UIButton!
    var commandsLabel:[Int: Command]!
    
    @IBAction func commandOnOffAction(_ sender: UISwitch) {
        commandSelectionPresenter.didSelectRow(atLabel: commandsLabel[sender.tag]!.rawValue)
    }
    
    @IBAction func settingButtonAction(_ sender: UIButton) {
        backButtonLabel.isHidden = false
        tableview.isHidden = true
        ndiDetaileView.isHidden = true
        compassDetaileView.isHidden = true

        if commandOnOff.tag == 4 {
            compassDetaileView.isHidden = false
        } else if commandOnOff.tag == 12 {
            ndiDetaileView.isHidden = false
        }
    }
    
    @IBAction func modalButtonAction(_ sender: UIButton) {
        modalParentButton.isHidden = false
        modalParentLabel.isHidden = false
    }
    
}
