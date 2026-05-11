//
//  StandardCell.swift
//  ZIGSIMPlus
//
//  Created by YoneyamaShunpei on 2019/06/06.
//  Copyright © 2019 1→10, Inc. All rights reserved.
//

import Foundation
import UIKit

protocol StandardCellDelegate: AnyObject {
    func showDetail(commandNo: Int)
    func showModal(commandNo: Int)
    func setSelectedButtonAvailable(_ selectedCommandNo: Int)
    func setNdiArkitImageDetectionButtonAvailable()
}

public class StandardCell: UITableViewCell {
    @IBOutlet var commandOnOffButton: UIButton!
    @IBOutlet var commandLabel: UILabel!
    @IBOutlet var checkMarkLabel: UILabel!
    @IBOutlet var detailButton: UIButton!
    @IBOutlet var detailImageView: UIImageView!
    @IBOutlet var modalButton: UIButton!
    @IBOutlet var labelConstaint: NSLayoutConstraint!
    weak var commandSelectionPresenter: CommandSelectionPresenterProtocol?
    weak var delegate: StandardCellDelegate?

    @IBAction func commandOnOffButtonAction(_ sender: UIButton) {
        setCheckMarkLabelText()
        setCommandsOfImageAvailability(sender)
        if checkMarkLabel.text == checkMark {
            commandSelectionPresenter?.saveCommandOnOffToUserDefaults(Command.allCases[sender.tag], true)
        } else {
            commandSelectionPresenter?.saveCommandOnOffToUserDefaults(Command.allCases[sender.tag], false)
        }
        commandSelectionPresenter?.didSelectRow(atLabel: Command.allCases[sender.tag].rawValue)
    }

    @IBAction func detailButtonAction(_: UIButton) {
        delegate?.showDetail(commandNo: commandOnOffButton.tag)
    }

    @IBAction func modalButtonAction(_: UIButton) {
        delegate?.showModal(commandNo: commandLabel.tag)
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
        if Command.allCases[sender.tag] == .ndi ||
            Command.allCases[sender.tag] == .arkit ||
            Command.allCases[sender.tag] == .imageDetection {
            if checkMarkLabel.text == checkMark {
                delegate?.setSelectedButtonAvailable(sender.tag)
            } else {
                delegate?.setNdiArkitImageDetectionButtonAvailable()
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
