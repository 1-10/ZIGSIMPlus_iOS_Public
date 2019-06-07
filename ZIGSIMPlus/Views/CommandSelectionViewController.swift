//
//  CommandSelectionViewController.swift
//  ZIGSIMPlus
//
//  Created by Nozomu Kuwae on 5/10/19.
//  Copyright © 2019 Nozomu Kuwae. All rights reserved.
//

import UIKit

typealias CommandToSelect = (labelString: String, isAvailable: Bool)

final class CommandSelectionViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backButtonLabel: UIButton!
    var presenter: CommandSelectionPresenterProtocol!
    let commandsLavel:[Int: Command] = [
        0: Command.acceleration,
        1: Command.gravity,
        2: Command.gyro,
        3: Command.quaternion,
        4: Command.compass,
        5: Command.pressure,
        6: Command.gps,
        7: Command.touch,
        8: Command.beacon,
        9: Command.proximity,
        10: Command.micLevel,
        11: Command.remoteControl,
        12: Command.ndi,
        13: Command.nfc,
        14: Command.arkit,
        15: Command.faceTracking,
        16: Command.battery,
        17: Command.applePencil
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backButtonLabel.isHidden = true
        self.tableView.register(UINib(nibName: "StandardCell", bundle: nil), forCellReuseIdentifier: "StandardCell")
    }
    
    @IBAction func backButon(_ sender: UIButton) {
        tableView.isHidden = false
        backButtonLabel.isHidden = true
    }
}

extension CommandSelectionViewController: UITableViewDelegate {
    
    // Disallow selecting unavailable command
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if let cell = tableView.cellForRow(at: indexPath) {
            let ip = tableView.indexPath(for: cell)!
            let CommandToSelect = presenter.getCommandToSelect(forRow: ip.row)
            if !CommandToSelect.isAvailable {
                return nil
            }
        }
        return indexPath
    }
}

extension CommandSelectionViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfCommandToSelect
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let CommandToSelect = self.presenter.getCommandToSelect(forRow: indexPath.row)
        let cell = tableView.dequeueReusableCell(withIdentifier: "StandardCell", for: indexPath) as! StandardCell
        
        cell.isUserInteractionEnabled = CommandToSelect.isAvailable
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.commandLabel.text = CommandToSelect.labelString
        cell.commandOnOff.tag = indexPath.row
        cell.commandSelectionPresenter = self.presenter
        cell.tableview = self.tableView
        cell.viewController = self
        cell.commandsLabel = self.commandsLavel
        cell.backButtonLabel = self.backButtonLabel
        cell.settingButton.isHidden = false
        
        if CommandToSelect.labelString == Command.acceleration.rawValue ||
           CommandToSelect.labelString == Command.gravity.rawValue ||
           CommandToSelect.labelString == Command.gyro.rawValue ||
           CommandToSelect.labelString == Command.quaternion.rawValue ||
           CommandToSelect.labelString == Command.pressure.rawValue ||
           CommandToSelect.labelString == Command.gps.rawValue ||
           CommandToSelect.labelString == Command.touch.rawValue ||
           CommandToSelect.labelString == Command.proximity.rawValue ||
           CommandToSelect.labelString == Command.micLevel.rawValue ||
           CommandToSelect.labelString == Command.remoteControl.rawValue {
           cell.settingButton.isHidden = true
        }
        
        if AppSettingModel.shared.isActiveByCommand[commandsLavel[indexPath.row]!] == true {
            cell.commandOnOff.isOn = true
        } else {
            cell.commandOnOff.isOn = false
        }
        
        return cell
        
    }
}

extension CommandSelectionViewController: CommandSelectionPresenterDelegate {
}
