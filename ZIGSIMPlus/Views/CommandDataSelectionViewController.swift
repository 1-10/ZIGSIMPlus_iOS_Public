//
//  CommandDataSelectionViewController.swift
//  ZIGSIMPlus
//
//  Created by Nozomu Kuwae on 5/10/19.
//  Copyright © 2019 Nozomu Kuwae. All rights reserved.
//

import UIKit

typealias CommandDataToSelect = (labelString: String, isAvailable: Bool)

final class CommandDataSelectionViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var presenter: CommandDataSelectionPresenterProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension CommandDataSelectionViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
            presenter.didSelectRow(atLabel: (cell.textLabel?.text)!)
            cell.accessoryType = (cell.accessoryType == .checkmark ? .none : .checkmark)
        }
    }

    // Disallow selecting unavailable command
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if let cell = tableView.cellForRow(at: indexPath) {
            let ip = tableView.indexPath(for: cell)!
            let commandDataToSelect = presenter.getCommandDataToSelect(forRow: ip.row)
            if !commandDataToSelect.isAvailable {
                return nil
            }
        }
        return indexPath
    }
}

extension CommandDataSelectionViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfCommandDataToSelect
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommandCell", for: indexPath)
        let commandDataToSelect = presenter.getCommandDataToSelect(forRow: indexPath.row)
        cell.textLabel!.text = commandDataToSelect.labelString
        cell.isUserInteractionEnabled = commandDataToSelect.isAvailable
        return cell
    }
}

extension CommandDataSelectionViewController: CommandDataSelectionPresenterDelegate {
}
