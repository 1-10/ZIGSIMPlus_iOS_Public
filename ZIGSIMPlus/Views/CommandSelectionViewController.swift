//
//  CommandSelectionViewController.swift
//  ZIGSIMPlus
//
//  Created by Nozomu Kuwae on 5/10/19.
//  Copyright © 2019 Nozomu Kuwae. All rights reserved.
//

import UIKit

final class CommandSelectionViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var presenter: CommandSelectionPresenterProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension CommandSelectionViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
            presenter.didSelectRow(atLabel: (cell.textLabel?.text)!)
            cell.accessoryType = (cell.accessoryType == .checkmark ? .none : .checkmark)
        }
    }
}

extension CommandSelectionViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfCommandLabels
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommandCell", for: indexPath)
        guard let functionLabel = presenter.getCommandLabel(forRow: indexPath.row) else { fatalError("Command nil") }
        cell.textLabel!.text = functionLabel
        return cell
    }
}

extension CommandSelectionViewController: CommandSelectionPresenterDelegate {
}
