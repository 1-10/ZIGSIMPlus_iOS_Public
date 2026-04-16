//
//  StandardCell.swift
//  ZIGSIMPlus
//
//  Created by YoneyamaShunpei on 2019/06/06.
//  Copyright © 2019 1→10, Inc. All rights reserved.
//

import Foundation
import UIKit

public class StandardCell: UITableViewCell {
    @IBOutlet var commandOnOffButton: UIButton!
    @IBOutlet var commandLabel: UILabel!
    @IBOutlet var checkMarkLabel: UILabel!
    @IBOutlet var detailButton: UIButton!
    @IBOutlet var detailImageView: UIImageView!
    @IBOutlet var modalButton: UIButton!
    @IBOutlet var labelConstaint: NSLayoutConstraint!
    var commandSelectionPresenter: CommandSelectionPresenterProtocol!
    var viewController: UIViewController!

    @IBAction func commandOnOffButtonAction(_ sender: UIButton) {
        setCheckMarkLabelText()
        setCommandsOfImageAvailability(sender)
        if checkMarkLabel.text == checkMark {
            commandSelectionPresenter.saveCommandOnOffToUserDefaults(Command.allCases[sender.tag], true)
        } else {
            commandSelectionPresenter.saveCommandOnOffToUserDefaults(Command.allCases[sender.tag], false)
        }
        commandSelectionPresenter.didSelectRow(atLabel: Command.allCases[sender.tag].rawValue)
    }

    @IBAction func detailButtonAction(_: UIButton) {
        guard let parent = viewController as? CommandSelectionViewController else { return }
        parent.showDetail(commandNo: commandOnOffButton.tag)
    }

    @IBAction func modalButtonAction(_: UIButton) {
        guard let parent = viewController as? CommandSelectionViewController else { return }
        parent.showModal(commandNo: commandLabel.tag)
    }

    func initCell() {
        backgroundColor = Theme.black
        checkMarkLabel.textColor = Theme.main
        checkMarkLabel.font = UIFont.boldSystemFont(ofSize: 23)
        modalButton.tintColor = Theme.main
        let screenWidth = UIScreen.main.bounds.size.width
        let newConstant = screenWidth - 195 // "195" is calibration constant adjusted to fit any devices.
        labelConstaint.constant = newConstant
    }

    func setCommandsOfImageAvailability(_ sender: UIButton) {
        guard let parent = viewController as? CommandSelectionViewController else { return }
        if Command.allCases[sender.tag] == .ndi ||
            Command.allCases[sender.tag] == .arkit ||
            Command.allCases[sender.tag] == .imageDetection {
            if checkMarkLabel.text == checkMark {
                parent.setSelectedButtonAvailable(sender.tag)
            } else {
                parent.setNdiArkitImageDetectionButtonAvailable()
            }
        }
    }

    func setCheckMarkLabelText() {
        if checkMarkLabel.text == "" {
            checkMarkLabel.text = checkMark
        } else {
            checkMarkLabel.text = ""
        }
    }
}
