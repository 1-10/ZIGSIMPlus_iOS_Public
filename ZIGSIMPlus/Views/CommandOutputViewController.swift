//
//  CommandOutputViewController.swift
//  ZIGSIMPlus
//
//  Created by Nozomu Kuwae on 5/10/19.
//  Copyright © 2019 Nozomu Kuwae. All rights reserved.
//

import UIKit
import MediaPlayer

class CommandOutputViewController: UIViewController {
    @IBOutlet weak var textField: UITextView!
    @IBOutlet weak var touchArea: UIView!

    var settings: [String:String] = [:]

    var presenter: CommandOutputPresenterProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        // Dummy volume view to disable default system volume hooks
        let volumeView = MPVolumeView(frame: CGRect(x: -100, y: -100, width: 0, height: 0))
        view.addSubview(volumeView)
        presenter.startCommands()
    }

    override func viewDidAppear(_ animated: Bool) {
        // Set area for touch points.
        // This has to be done after auto layout.
        TouchService.shared.setTouchArea(rect: touchArea.bounds)
    }

    override func viewDidDisappear(_ animated: Bool) {
        presenter.stopCommands()
    }

    // MARK: - Touch Events

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        TouchService.shared.addTouches(touches)
    }   

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        TouchService.shared.updateTouches(touches)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        TouchService.shared.removeTouches(touches)
    }

    override func touchesCancelled(_ touches: Set<UITouch>?, with event: UIEvent?) {
        TouchService.shared.removeAllTouches()
    }
}

extension CommandOutputViewController: CommandOutputPresenterDelegate {
    func updateOutput(with output: String) {
        textField.text = output
    }

    func updateSettings(with newSettings: [String : String]) {
        settings = newSettings
    }
}

extension CommandOutputViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if let cell = tableView.cellForRow(at: indexPath) {
//            tableView.deselectRow(at: indexPath, animated: true)
//            presenter.didSelectRow(atLabel: (cell.textLabel?.text)!)
//            cell.accessoryType = (cell.accessoryType == .checkmark ? .none : .checkmark)
//        }
//    }

    // Disallow selecting unavailable command
//    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
//        if let cell = tableView.cellForRow(at: indexPath) {
//            let ip = tableView.indexPath(for: cell)!
//            let CommandToSelect = presenter.getCommandToSelect(forRow: ip.row)
//            if !CommandToSelect.isAvailable {
//                return nil
//            }
//        }
//        return indexPath
//    }
}

extension CommandOutputViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingCell", for: indexPath)

        let key = [String](settings.keys)[indexPath.row]
        let value = settings[key]

        cell.textLabel!.text = key + ":" + value!
//        cell.isUserInteractionEnabled = CommandToSelect.isAvailable
        return cell
    }
}
