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
        setImageSegmentsAvailability(sender)
        if sender.isOn {
            commandSelectionPresenter.saveCommandOnOffToUserDefaults(Command.allCases[sender.tag], true)
        } else {
            commandSelectionPresenter.saveCommandOnOffToUserDefaults(Command.allCases[sender.tag], false)
        }
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
        commandOnOff.thumbTintColor = Theme.gray
        commandOnOff.onTintColor = Theme.main
        commandOnOff.tintColor = Theme.main
        commandOnOff.backgroundColor = Theme.black
        commandOnOff.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        detailButton.setStyle(.caretRight, animated: true)
        modalButton.backgroundColor = Theme.gray
        modalButton.layer.borderWidth = 2.0
        modalButton.layer.borderColor = Theme.gray.cgColor
        modalButton.layer.cornerRadius = 10.0
        let screenWidth = UIScreen.main.bounds.size.width
        let newConstant = screenWidth - 300 // "300" is a length other than this constant
        labelConstaint.constant = newConstant
    }
    
    func setImageSegmentsAvailability(_ sender: UISwitch) {
        let parent = viewController as! CommandSelectionViewController
        if (Command.allCases[sender.tag] == .ndi ||
            Command.allCases[sender.tag] == .arkit ||
            Command.allCases[sender.tag] == .imageDetection) {
            if sender.isOn{
                parent.setImageSegmentsUnavailable(sender.tag)
            } else {
                parent.setImageSegmentsAvailable()
            }
        }
    }
}
