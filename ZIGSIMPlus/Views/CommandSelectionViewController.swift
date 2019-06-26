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
    var presenter: CommandSelectionPresenterProtocol!
    var alert: UIAlertController = UIAlertController() // dummy

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib(nibName: "StandardCell", bundle: nil), forCellReuseIdentifier: "StandardCell")
        adjustViewDesign()
    }
    
    func showDetail(commandNo: Int) {
        let command = Command.allCases[commandNo]

        // Get detail view controller
        switch command {
        case .compass, .ndi, .arkit, .beacon, .imageDetection:
            let vc = storyboard!.instantiateViewController(withIdentifier: "CommandDetailSettingsView") as! CommandDetailSettingsViewController
            vc.command = command

            // Move to detail view
            guard let navCtrl = navigationController else {
                fatalError("CommandSelectionView must be embedded in NavigationController")
            }
            navCtrl.pushViewController(vc, animated: true)

        default:
            return // Do nothing if detail view for the command is not found
        }
    }

    func showModal(commandNo: Int) {
        let command = Command.allCases[commandNo]

        guard let (title: title, body: msg) = modalTexts[command] else {
            fatalError("Invalid command: \(command)")
        }

        alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "See Docs", style: .default, handler: { action in
            UIApplication.shared.open(URL(string: "https://zig-project.com/")!, options: [:])
        }))
        alert.addAction(UIAlertAction(title: "OK", style: .default))

        present(alert, animated: true, completion: {
            self.alert.view.superview?.isUserInteractionEnabled = true
            self.alert.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.hideAlert)))
        })
    }

    @objc private func hideAlert() {
        alert.dismiss(animated: true, completion: nil)
    }
    
    private func adjustViewDesign() {
        Utils.setTitleImage(navigationController!.navigationBar)
        navigationController?.navigationBar.barTintColor = Theme.dark
        navigationController?.navigationBar.tintColor = Theme.main
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
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        tableView.separatorStyle = .none
        tableView.backgroundColor = Theme.dark
        
        cell.commandLabel.text = CommandToSelect.labelString
        cell.commandLabel.tag = indexPath.row
        cell.commandOnOff.tag = indexPath.row
        cell.viewController = self
        cell.commandSelectionPresenter = self.presenter
        
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

        if AppSettingModel.shared.isActiveByCommand[Command.allCases[indexPath.row]] == true {
            cell.commandOnOff.isOn = true
        } else {
            cell.commandOnOff.isOn = false
        }
        
        let mediator = CommandAndServiceMediator()
        if mediator.isAvailable(Command.allCases[indexPath.row]){
            setAvailable(true, forCell:cell)
        } else {
            setAvailable(false, forCell:cell)
        }

        cell.initCell()
        
        return cell
    }
    
    func setAvailable(_ isAvailable: Bool, forCell cell: StandardCell) {
        cell.commandOnOff.isEnabled = isAvailable
        cell.detailButton.isEnabled = isAvailable
        if isAvailable {
            cell.commandLabel.textColor = UIColor(displayP3Red: 2/255, green: 141/255, blue: 90/255, alpha: 1.0)
            cell.detailButton.strokeColor = UIColor(displayP3Red: 2/255, green: 141/255, blue: 90/255, alpha: 1.0)
        } else {
            cell.commandLabel.textColor = UIColor(displayP3Red: 103/255, green: 103/255, blue: 103/255, alpha: 1.0)
            cell.detailButton.strokeColor = UIColor(displayP3Red: 103/255, green: 103/255, blue: 103/255, alpha: 1.0)
        }
    }
}

extension CommandSelectionViewController: CommandSelectionPresenterDelegate {
}
