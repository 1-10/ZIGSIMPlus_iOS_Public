//
//  StandardCell.swift
//  ZIGSIMPlus
//
//  Created by YoneyamaShunpei on 2019/06/06.
//  Copyright © 2019 Nozomu Kuwae. All rights reserved.
//

import Foundation
import UIKit
import DynamicButton

public class StandardCell: UITableViewCell {
   
    @IBOutlet weak var commandOnOff: UISwitch!
    @IBOutlet weak var commandLabel: UILabel!
    @IBOutlet weak var detailButton: DynamicButton!
    @IBOutlet weak var modalButton: UIButton!
    @IBOutlet weak var labelConstaint: NSLayoutConstraint!
    var commandSelectionPresenter: CommandSelectionPresenterProtocol!
    var viewController: UIViewController!
    
    @IBAction func commandOnOffAction(_ sender: UISwitch) {
        commandSelectionPresenter.didSelectRow(atLabel: Command.allCases[sender.tag].rawValue)
    }
    
    @IBAction func detailButtonAction(_ sender: UIButton) {
        let parent = viewController as! CommandSelectionViewController
        parent.showDetail(commandNo: commandOnOff.tag)
    }
    
    @IBAction func modalButtonAction(_ sender: UIButton) {
        let parent = viewController as! CommandSelectionViewController
        parent.showModal(commandNo: commandLabel.tag)
    }
    
    func initCell() {
        // label
        commandLabel.textColor = UIColor(displayP3Red: 2/255, green: 141/255, blue: 90/255, alpha: 1.0)
        // switch controller
        commandOnOff.thumbTintColor = UIColor(displayP3Red: 103/255, green: 103/255, blue: 103/255, alpha: 1.0)
        commandOnOff.onTintColor = UIColor(displayP3Red: 2/255, green: 141/255, blue: 90/255, alpha: 1.0)
        commandOnOff.tintColor = UIColor(displayP3Red: 2/255, green: 141/255, blue: 90/255, alpha: 1.0)
        commandOnOff.backgroundColor = UIColor(displayP3Red: 13/255, green: 12/255, blue: 12/255, alpha: 1.0)
        commandOnOff.layer.cornerRadius = commandOnOff.frame.size.height/2;
        // detail button
        detailButton.setStyle(.caretRight, animated: true)
        detailButton.strokeColor = UIColor(displayP3Red: 2/255, green: 141/255, blue: 90/255, alpha: 1.0)
        modalButton.backgroundColor = UIColor(displayP3Red: 103/255, green: 103/255, blue: 103/255, alpha: 1.0)
        // modal button
        modalButton.layer.borderWidth = 2.0
        modalButton.layer.borderColor = UIColor(displayP3Red: 103/255, green: 103/255, blue: 103/255, alpha: 1.0).cgColor
        modalButton.layer.cornerRadius = 10.0
        // constant
        let screenWidth = UIScreen.main.bounds.size.width
        let newConstant = screenWidth - 300 // "300" is a length other than this constant
        labelConstaint.constant = newConstant

    }
    
}
