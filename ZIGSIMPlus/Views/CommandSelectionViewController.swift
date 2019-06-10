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
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var modalLabel: UILabel!
    @IBOutlet weak var modalButton: UIButton!
    @IBOutlet weak var ndiDetailView: UIView!
    @IBOutlet weak var compassDetailView: UIView!
    
    var presenter: CommandSelectionPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backButton.isHidden = true
        modalLabel.isHidden = true
        modalButton.isHidden = true
        self.tableView.register(UINib(nibName: "StandardCell", bundle: nil), forCellReuseIdentifier: "StandardCell")
    }
    
    
    @IBAction func actionButton(_ sender: UIButton) {
        if sender.tag == 0 { // sender.tag == 0 is "modalButton"
            modalLabel.isHidden = true
            modalButton.isHidden = true
        } else if sender.tag == 1 { // sender.tag == 1 is "backButton"
            tableView.isHidden = false
            backButton.isHidden = true
        }
    }
    
    func showDetail(commandNo: Int) {
        backButton.isHidden = false
        tableView.isHidden = true
        ndiDetailView.isHidden = true
        compassDetailView.isHidden = true
        let command = Command.allCases[commandNo]
        if command == .compass {
            compassDetailView.isHidden = false
        } else if command == .ndi {
            ndiDetailView.isHidden = false
        }
    }
    
    func showModal(commandNo: Int) {
        modalLabel.isHidden = false
        modalButton.isHidden = false
        modalLabel.numberOfLines = 10
        let command = Command.allCases[commandNo]
        modalLabel.text = modalTexts[command]
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
        
        // Set cell's tap action style
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        // Set cell's variable
        cell.commandLabel.text = CommandToSelect.labelString
        cell.commandLabel.tag = indexPath.row
        cell.commandOnOff.tag = indexPath.row
        cell.viewController = self
        cell.commandSelectionPresenter = self.presenter
        
        // Set cell's detail button to visible or invisible
        cell.detailButton.isHidden = false
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
           cell.detailButton.isHidden = true
        }

        // Make an adjustment table view screen
        if AppSettingModel.shared.isActiveByCommand[Command.allCases[indexPath.row]] == true {
            cell.commandOnOff.isOn = true
        } else {
            cell.commandOnOff.isOn = false
        }
        
        return cell
    }
}

extension CommandSelectionViewController: CommandSelectionPresenterDelegate {
}
