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
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var textPreview: UIView!
    @IBOutlet weak var imagePreview: UIView!
    @IBOutlet weak var togglePreviewModeButton: UIBarButtonItem!
    private var isTextPreviewMode: Bool = true

    @IBOutlet weak var settingsTable: UITableView!
    var settings: [(String, String)] = []

    var presenter: CommandOutputPresenterProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Initialize navigation bar
        let titleImage = UIImage(named: "Logo")
        let titleImageView = UIImageView(image: titleImage)
        titleImageView.contentMode = .scaleAspectFit
        navItem.titleView = titleImageView

        presenter.composeChildViewArchitecture()
    }

    override func viewWillAppear(_ animated: Bool) {
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

    override func viewDidAppear(_ animated: Bool) {
        // Set area for touch points.
        // This has to be done after auto layout.
        touchArea.isHidden = !presenter.isTouchEnabled()
        TouchService.shared.setTouchArea(rect: touchArea.bounds)
    }

    override func viewDidDisappear(_ animated: Bool) {
        presenter.stopCommands()
    }

    @IBAction func togglePreviewMode(_ sender: Any) {
        isTextPreviewMode.toggle()
        updatePreviewMode()
    }

    private func updatePreviewMode() {
        textPreview.isHidden = !isTextPreviewMode
        imagePreview.isHidden = isTextPreviewMode
        togglePreviewModeButton.tintColor = isTextPreviewMode ? nil : Theme.negative
    }

    // MARK: - Touch Events

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        TouchService.shared.addTouches(Array(touches))
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        TouchService.shared.updateTouches(Array(touches))
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        TouchService.shared.removeTouches(Array(touches))
    }

    override func touchesCancelled(_ touches: Set<UITouch>?, with event: UIEvent?) {
        TouchService.shared.removeAllTouches()
    }
}

extension CommandOutputViewController: CommandOutputPresenterDelegate {
    func updateOutput(with log: String, errorLog: String) {
        let output = errorLog == "" ? log : "\(errorLog)\n\n\(log)"
        let attributedString = NSMutableAttributedString(string: output)

        // Set attributes for normal logs
        let allRange = NSRange(location: 0, length: output.count)
        attributedString.setAttributes(textField.typingAttributes, range: allRange)
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: Theme.main, range: allRange)

        // Add attribute for error logs
        let errorRange = NSRange(location: 0, length: errorLog.count)
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: Theme.error, range: errorRange)

        textField.attributedText = attributedString
    }

    func updateSettings(with newSettings: [(String, String)]) {
        settings = newSettings
        settingsTable.reloadData()
    }
}

extension CommandOutputViewController: UITableViewDelegate {}

extension CommandOutputViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
