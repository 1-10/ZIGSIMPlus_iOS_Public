//
//  CommandSelectionViewController.swift
//  ZIGSIMPlus
//
//  Created by Nozomu Kuwae on 5/10/19.
//  Copyright © 2019 1→10, Inc. All rights reserved.
//

import MarkdownKit
import SVProgressHUD
import UIKit

typealias CommandToSelect = (labelString: String, isAvailable: Bool)

final class CommandSelectionViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    var presenter: CommandSelectionPresenterProtocol!
    var cells: [Command: StandardCell] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.loadCommandOnOffFromUserDefaults()
        tableView.register(UINib(nibName: "StandardCell", bundle: nil), forCellReuseIdentifier: "StandardCell")
        adjustNavigationDesign()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    func setNdiArkitImageDetectionButtonAvailable() {
        setAvailable(true, forCell: cells[Command.ndi])
        setAvailable(true, forCell: cells[Command.arkit])
        setAvailable(true, forCell: cells[Command.imageDetection])
    }

    func setSelectedButtonAvailable(_ selectedCommandNo: Int) {
        let selectedCommand = Command.allCases[selectedCommandNo]
        switch selectedCommand {
        case .ndi:
            setAvailable(false, forCell: cells[Command.arkit])
            setAvailable(false, forCell: cells[Command.imageDetection])
        case .arkit:
            setAvailable(false, forCell: cells[Command.imageDetection])
            setAvailable(false, forCell: cells[Command.ndi])
        case .imageDetection:
            setAvailable(false, forCell: cells[Command.ndi])
            setAvailable(false, forCell: cells[Command.arkit])
        default:
            return
        }
    }

    public func showDetail(commandNo: Int) {
        let command = Command.allCases[commandNo]

        // Get detail view controller
        switch command {
        case .compass, .ndi, .arkit, .beacon, .imageDetection:
            // swiftlint:disable:next line_length force_cast
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

    public func showModal(commandNo: Int) {
        let command = Command.allCases[commandNo]

        guard let (title: title, body: msg) = modalTexts[command] else {
            fatalError("Invalid command: \(command)")
        }

        showAlertWithMarkdownMessage(title: title, message: msg)
    }

    func showAlertWithMarkdownMessage(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let attributedText = convertMessageFromStringToAttributedText(message)
        alert.setValue(attributedText, forKey: "attributedMessage")
        alert.addAction(UIAlertAction(title: "See Docs", style: .default, handler: { _ in
            UIApplication.shared.open(URL(string: "https://1-10.github.io/zigsim/")!, options: [:])
        }))
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true, completion: {
            alert.view.superview?.isUserInteractionEnabled = true
        })
    }

    private func adjustNavigationDesign() {
        Utils.setTitleImage(navigationController!.navigationBar)
        navigationController?.navigationBar.barTintColor = Theme.dark
        navigationController?.navigationBar.tintColor = Theme.main
    }

    private func convertMessageFromStringToAttributedText(_ msg: String) -> NSMutableAttributedString {
        let markdownParser = MarkdownParser()
        return NSMutableAttributedString(attributedString: markdownParser.parse(msg))
    }
}

extension CommandSelectionViewController: UITableViewDelegate {
    // Disallow selecting unavailable command
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if let cell = tableView.cellForRow(at: indexPath) {
            let ipForCell = tableView.indexPath(for: cell)!
            let commandToSelect = presenter.getCommandToSelect(forRow: ipForCell.row)
            if !commandToSelect.isAvailable {
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
        let commandToSelect = presenter.getCommandToSelect(forRow: indexPath.row)

        // swiftlint:disable:next force_cast
        let cell = tableView.dequeueReusableCell(withIdentifier: "StandardCell", for: indexPath) as! StandardCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        tableView.separatorStyle = .none
        tableView.backgroundColor = Theme.black
        cell.commandLabel.text = commandToSelect.labelString
        cell.commandLabel.tag = indexPath.row
        cell.commandOnOffButton.tag = indexPath.row
        cell.viewController = self
        cell.commandSelectionPresenter = presenter
        cells[Command.allCases[indexPath.row]] = cell

        if AppSettingModel.shared.isActiveByCommand[Command.allCases[indexPath.row]]! {
            cell.checkMarkLavel.text = checkMark
        } else {
            cell.checkMarkLavel.text = ""
        }

        if CommandAndServiceMediator.isAvailable(Command.allCases[indexPath.row]) {
            setAvailable(true, forCell: cell)
        } else {
            setAvailable(false, forCell: cell)
        }

        cell.initCell()

        return cell
    }

    func setAvailable(_ isAvailable: Bool, forCell cell: StandardCell?) {
        cell?.commandOnOffButton.isEnabled = isAvailable
        cell?.detailButton.isEnabled = isAvailable
        if isAvailable {
            cell?.commandLabel.textColor = Theme.main
            cell?.detailButton.tintColor = Theme.main
            setDetailButton(isCommandAvailable: true, forCell: cell)
        } else {
            cell?.commandLabel.textColor = Theme.dark
            cell?.detailButton.tintColor = Theme.dark
            setDetailButton(isCommandAvailable: false, forCell: cell)
        }
    }

    func setDetailButton(isCommandAvailable: Bool, forCell cell: StandardCell?) {
        if hasDetailView(commandLabel: cell?.commandLabel.text) {
            cell?.detailButton.isHidden = false
            cell?.detailImageView.isHidden = false
            let image: UIImage?
            if isCommandAvailable {
                image = UIImage(named: "ActiveDetailButton")
            } else {
                image = UIImage(named: "UnactiveDetailButton")
            }
            cell?.detailImageView.image = image
        } else {
            cell?.detailButton.isHidden = true
            cell?.detailImageView.isHidden = true
        }
    }

    func hasDetailView(commandLabel: String?) -> Bool {
        if commandLabel == Command.ndi.rawValue ||
            commandLabel == Command.arkit.rawValue ||
            commandLabel == Command.imageDetection.rawValue ||
            commandLabel == Command.compass.rawValue ||
            commandLabel == Command.beacon.rawValue {
            return true
        }
        return false
    }
}

extension CommandSelectionViewController: CommandSelectionPresenterDelegate {}
