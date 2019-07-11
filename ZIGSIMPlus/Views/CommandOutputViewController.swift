//
//  CommandOutputViewController.swift
//  ZIGSIMPlus
//
//  Created by Nozomu Kuwae on 5/10/19.
//  Copyright © 2019 1→10, Inc. All rights reserved.
//

import MediaPlayer
import UIKit

class CommandOutputViewController: UIViewController {
    @IBOutlet var textField: UITextView!
    @IBOutlet var touchArea: UIView!
    @IBOutlet var textPreview: UIView!
    @IBOutlet var imagePreview: UIView!
    @IBOutlet var togglePreviewModeButton: UIBarButtonItem!
    private var isTextPreviewMode: Bool = true

    @IBOutlet var settingsTable: UITableView!
    var settings: [(String, String)] = []

    var presenter: CommandOutputPresenterProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Initialize navigation bar
        let navBar = navigationController!.navigationBar
        navBar.barTintColor = Theme.dark
        navBar.tintColor = Theme.main
        Utils.setTitleImage(navBar)

        presenter.composeChildViewArchitecture()
    }

    override func viewWillAppear(_: Bool) {
        // Dummy volume view to disable default system volume hooks
        let volumeView = MPVolumeView(frame: CGRect(x: -100, y: -100, width: 0, height: 0))
        view.addSubview(volumeView)
        presenter.startCommands()

        // Update camera button state
        let isCameraUsed = presenter.isCameraUsed()
        togglePreviewModeButton.isEnabled = isCameraUsed
        isTextPreviewMode = isTextPreviewMode || !isCameraUsed

        updatePreviewMode()
    }

    override func viewDidAppear(_: Bool) {
        // Set area for touch points.
        // This has to be done after auto layout.
        touchArea.isHidden = !presenter.isTouchEnabled()
        TouchService.shared.setTouchArea(rect: touchArea.bounds)
    }

    override func viewDidDisappear(_: Bool) {
        presenter.stopCommands()
    }

    @IBAction func togglePreviewMode(_: Any) {
        isTextPreviewMode.toggle()
        updatePreviewMode()
    }

    private func updatePreviewMode() {
        textPreview.isHidden = !isTextPreviewMode
        imagePreview.isHidden = isTextPreviewMode
        togglePreviewModeButton.tintColor = isTextPreviewMode ? nil : Theme.warn
    }

    // MARK: - Touch Events

    override func touchesBegan(_ touches: Set<UITouch>, with _: UIEvent?) {
        TouchService.shared.addTouches(Array(touches))
    }

    override func touchesMoved(_ touches: Set<UITouch>, with _: UIEvent?) {
        TouchService.shared.updateTouches(Array(touches))
    }

    override func touchesEnded(_ touches: Set<UITouch>, with _: UIEvent?) {
        TouchService.shared.removeTouches(Array(touches))
    }

    override func touchesCancelled(_: Set<UITouch>?, with _: UIEvent?) {
        TouchService.shared.removeAllTouches()
    }
}

extension CommandOutputViewController: CommandOutputPresenterDelegate {
    func updateOutput(with log: String, errorLog: String?) {
        if errorLog == nil {
            textField.text = log
        } else {
            let output = "\(errorLog!)\n\n\(log)"
            let attributedString = NSMutableAttributedString(string: output)

            // Set attributes for normal logs
            let allRange = NSRange(location: 0, length: output.count)
            attributedString.setAttributes(textField.typingAttributes, range: allRange)
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: Theme.main, range: allRange)

            // Add attribute for error logs
            let errorRange = NSRange(location: 0, length: errorLog!.count)
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: Theme.error, range: errorRange)

            textField.attributedText = attributedString
        }
    }

    func updateSettings(with newSettings: [(String, String)]) {
        settings = newSettings
        settingsTable.reloadData()
    }
}

extension CommandOutputViewController: UITableViewDelegate {}

extension CommandOutputViewController: UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return settings.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingCell", for: indexPath)

        if let c = cell as? CommandOutputViewSettingsTableCell {
            let kv = settings[indexPath.row]
            c.setKeyValue(kv.0, kv.1)
        }

        return cell
    }
}
