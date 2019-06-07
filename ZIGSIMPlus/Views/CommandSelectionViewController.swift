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
    
    /*
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
            presenter.didSelectRow(atLabel: (cell.textLabel?.text)!)
            cell.accessoryType = (cell.accessoryType == .checkmark ? .none : .checkmark)
        }
    }
    */

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
        /*
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommandCell", for: indexPath)
        let CommandToSelect = presenter.getCommandToSelect(forRow: indexPath.row)
        cell.textLabel!.text = CommandToSelect.labelString
        cell.isUserInteractionEnabled = CommandToSelect.isAvailable
        return cell
        */
        let Commands = presenter.getCommandToSelect(forRow: indexPath.row)
        let CommandToSelect = presenter.getCommandToSelect(forRow: indexPath.row)
        let cell = tableView.dequeueReusableCell(withIdentifier: "StandardCell", for: indexPath) as! StandardCell
        cell.isUserInteractionEnabled = CommandToSelect.isAvailable
        cell.commandLabel.text = CommandToSelect.labelString
        cell.commandOnOff.tag = indexPath.row
        cell.commandOnOff.setOn(false, animated: false)
        cell.commandSelectionPresenter = presenter
        cell.tableview = self.tableView
        cell.viewController = self
        cell.backButtonLabel = self.backButtonLabel
        cell.settingButton.isHidden = false
        
        if Commands.labelString == Command.acceleration.rawValue ||
           Commands.labelString == Command.gravity.rawValue ||
           Commands.labelString == Command.gyro.rawValue ||
           Commands.labelString == Command.quaternion.rawValue ||
           Commands.labelString == Command.pressure.rawValue ||
           Commands.labelString == Command.gps.rawValue ||
           Commands.labelString == Command.touch.rawValue ||
           Commands.labelString == Command.proximity.rawValue ||
           Commands.labelString == Command.micLevel.rawValue ||
           Commands.labelString == Command.remoteControl.rawValue {
           cell.settingButton.isHidden = true
        }
        
        return cell
        
    }
}

extension CommandSelectionViewController: CommandSelectionPresenterDelegate {
}
