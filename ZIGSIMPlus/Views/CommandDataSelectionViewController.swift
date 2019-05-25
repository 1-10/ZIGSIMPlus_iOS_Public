//
//  CommandDataSelectionViewController.swift
//  ZIGSIMPlus
//
//  Created by Nozomu Kuwae on 5/10/19.
//  Copyright © 2019 Nozomu Kuwae. All rights reserved.
//

import UIKit

typealias CommandDataToSelect = (label: String, isAvailable: Bool)

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
}

extension CommandDataSelectionViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfCommandDataToSelect
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommandCell", for: indexPath)
        guard let commandDataToSelect = presenter.getCommandDataToSelect(forRow: indexPath.row) else { fatalError("CommandData  nil") }
        cell.textLabel!.text = commandDataToSelect.label
        cell.isUserInteractionEnabled = commandDataToSelect.isAvailable
        return cell
    }
}

extension CommandDataSelectionViewController: CommandDataSelectionPresenterDelegate {
}
