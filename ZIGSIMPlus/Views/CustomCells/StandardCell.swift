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
    @IBOutlet var checkMarkLavel: UILabel!
    @IBOutlet var detailButton: UIButton!
    @IBOutlet var detailImageView: UIImageView!
    @IBOutlet var modalButton: UIButton!
    @IBOutlet var labelConstaint: NSLayoutConstraint!
    var commandSelectionPresenter: CommandSelectionPresenterProtocol!
    var viewController: UIViewController!

    @IBAction func commandOnOffButtonAction(_ sender: UIButton) {
        setCheckMarkLavelText()
        setCommandsOfImageAvailability(sender)
        if checkMarkLavel.text == checkMark {
            commandSelectionPresenter.saveCommandOnOffToUserDefaults(Command.allCases[sender.tag], true)
        } else {
            commandSelectionPresenter.saveCommandOnOffToUserDefaults(Command.allCases[sender.tag], false)
        }
        commandSelectionPresenter.didSelectRow(atLabel: Command.allCases[sender.tag].rawValue)
    }

    @IBAction func detailButtonAction(_: UIButton) {
        // swiftlint:disable:next force_cast
        let parent = viewController as! CommandSelectionViewController
        parent.showDetail(commandNo: commandOnOffButton.tag)
    }

    @IBAction func modalButtonAction(_: UIButton) {
        // swiftlint:disable:next force_cast
        let parent = viewController as! CommandSelectionViewController
        parent.showModal(commandNo: commandLabel.tag)
    }

    func initCell() {
        backgroundColor = Theme.black
        checkMarkLavel.textColor = Theme.main
        checkMarkLavel.font = UIFont.boldSystemFont(ofSize: 23)
        modalButton.tintColor = Theme.main
        let screenWidth = UIScreen.main.bounds.size.width
        let newConstant = screenWidth - 195 // "195" is calibration constant adjusted to fit any devices.
        labelConstaint.constant = newConstant
    }

    func setCommandsOfImageAvailability(_ sender: UIButton) {
        let parent = viewController as! CommandSelectionViewController // swiftlint:disable:this force_cast
        if Command.allCases[sender.tag] == .ndi ||
            Command.allCases[sender.tag] == .arkit ||
            Command.allCases[sender.tag] == .imageDetection {
            if checkMarkLavel.text == checkMark {
                parent.setSelectedButtonAvailable(sender.tag)
            } else {
                parent.setNdiArkitImageDetectionButtonAvailable()
            }
        }
    }

    func setCheckMarkLavelText() {
        if checkMarkLavel.text == "" {
            checkMarkLavel.text = checkMark
        } else {
            checkMarkLavel.text = ""
        }
    }
}
