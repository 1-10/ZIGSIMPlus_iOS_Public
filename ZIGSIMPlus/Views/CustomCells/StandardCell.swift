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
    var viewController: UIViewController!
    
    @IBAction func commandOnOffAction(_ sender: UISwitch) {
        commandSelectionPresenter.didSelectRow(atLabel: commandsNumber[sender.tag]!.rawValue)
    }
    
    @IBAction func settingButtonAction(_ sender: UIButton) {
        let parent = viewController as! CommandSelectionViewController
        parent.showDetaile(commandNo: commandOnOff.tag)
    }
    
    @IBAction func modalButtonAction(_ sender: UIButton) {
        let parent = viewController as! CommandSelectionViewController
        parent.showModal(commandNo: commandLabel.tag)
    }
    
}
