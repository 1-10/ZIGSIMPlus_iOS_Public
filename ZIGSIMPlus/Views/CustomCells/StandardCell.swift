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

    @IBOutlet weak var commandOnOffButton: UIButton!
    @IBOutlet weak var commandLabel: UILabel!
    @IBOutlet weak var checkMarkLavel: UILabel!
    @IBOutlet weak var detailButton: UIButton!
    @IBOutlet weak var detailImageView: UIImageView!
    @IBOutlet weak var modalButton: UIButton!
    @IBOutlet weak var labelConstaint: NSLayoutConstraint!
    var commandSelectionPresenter: CommandSelectionPresenterProtocol!
    var viewController: UIViewController!
    
    @IBAction func commandOnOffButtonAction(_ sender: UIButton) {
        setCheckMarkLavelText()
        setCommandsOfImageAvailability(sender)
        commandSelectionPresenter.didSelectRow(atLabel: Command.allCases[sender.tag].rawValue)
    }
    
    @IBAction func detailButtonAction(_ sender: UIButton) {
        let parent = viewController as! CommandSelectionViewController
        parent.showDetail(commandNo: commandOnOffButton.tag)
    }

    @IBAction func modalButtonAction(_ sender: UIButton) {
        let parent = viewController as! CommandSelectionViewController
        parent.showModal(commandNo: commandLabel.tag)
    }
    
    func initCell() {
        self.backgroundColor = Theme.black
        checkMarkLavel.textColor = Theme.main
        checkMarkLavel.font = UIFont.boldSystemFont(ofSize: 23)
        modalButton.tintColor = Theme.main
        let screenWidth = UIScreen.main.bounds.size.width
        let newConstant = screenWidth - 195 // "195" is calibration constant adjusted to fit any devices.
        labelConstaint.constant =  newConstant
    }
    
    func setCommandsOfImageAvailability(_ sender: UIButton) {
        let parent = viewController as! CommandSelectionViewController
        if Command.allCases[sender.tag] == .ndi || Command.allCases[sender.tag] == .arkit || Command.allCases[sender.tag] == .imageDetection{
            if checkMarkLavel.text == "\u{2713}" { // "\u{2713}" is "✔︎"
                parent.setSelectedButtonAvailable(sender.tag)
            } else {
                parent.setNdiArkitImageDetectionButtonAvailable()
            }
        }
    }
    
    func setCheckMarkLavelText() {
        if checkMarkLavel.text == "" {
            checkMarkLavel.text = "\u{2713}" // "\u{2713}" is "✔︎"
        } else  {
            checkMarkLavel.text = ""
        }
    }
}
