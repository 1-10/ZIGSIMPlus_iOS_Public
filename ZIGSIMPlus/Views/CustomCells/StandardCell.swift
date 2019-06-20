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
        commandLabel.textColor = Theme.main
        commandOnOff.thumbTintColor = Theme.lightGray
        commandOnOff.onTintColor = Theme.main
        commandOnOff.tintColor = Theme.main
        commandOnOff.backgroundColor = Theme.dark
        commandOnOff.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        detailButton.setStyle(.caretRight, animated: true)
        detailButton.strokeColor = Theme.main
        modalButton.backgroundColor = Theme.lightGray
        modalButton.layer.borderWidth = 2.0
        modalButton.layer.borderColor = Theme.lightGray.cgColor
        modalButton.layer.cornerRadius = 10.0
        let screenWidth = UIScreen.main.bounds.size.width
        let newConstant = screenWidth - 300 // "300" is a length other than this constant
        labelConstaint.constant = newConstant
    }
}
