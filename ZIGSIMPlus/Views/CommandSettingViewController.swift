//
//  CommandSettingViewPresenter.swift
//  ZIGSIMPlus
//
//  Created by YoneyamaShunpei on 2019/05/23.
//  Copyright © 2019 1→10, Inc. All rights reserved.
//
import Foundation
import UIKit

protocol ContentScrollable {
    var scrollView: UIScrollView! { get }
    func configureObserver()
    func removeObserver()
}

public class CommandSettingViewController: UIViewController {
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var labels: [UILabel]!
    @IBOutlet var segments: [UISegmentedControl]!
    @IBOutlet var textFields: [UITextField]!
    var presenter: CommandSettingPresenterProtocol!

    var showObserver: NSObjectProtocol?
    var hideObserver: NSObjectProtocol?

    public override func viewDidLoad() {
        super.viewDidLoad()

        let userDefaultTexts = presenter.getUserDefaultTexts()
        for textField in textFields {
            if textField.tag == 0 {
                setTextFieldSetting(texField: textField, text: userDefaultTexts[.ipAddress]?.description ?? "")
            } else if textField.tag == 1 {
                setTextFieldSetting(texField: textField, text: userDefaultTexts[.portNumber]?.description ?? "")
            } else if textField.tag == 2 {
                setTextFieldSetting(texField: textField, text: userDefaultTexts[.uuid]?.description ?? "")
            }
        }

        let userDefaultSegments = presenter.getUserDefaultSegments()

        for segment in segments {
            if segment.tag == 0 {
                segment.selectedSegmentIndex = userDefaultSegments[.dataDestination] ?? 0
            } else if segment.tag == 1 {
                segment.selectedSegmentIndex = userDefaultSegments[.dataProtocol] ?? 0
            } else if segment.tag == 2 {
                segment.selectedSegmentIndex = userDefaultSegments[.messageFormat] ?? 0
            } else if segment.tag == 3 {
                segment.selectedSegmentIndex = userDefaultSegments[.messageRatePerSecond] ?? 0
            }
            // Because the specification of UISegmentedControl has changed from iOS13
            segment.selectedSegmentTintColor = Theme.main
            segment.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: Theme.main], for: .normal)
            segment.layer.borderWidth = 1
            segment.layer.borderColor = Theme.main.cgColor
        }

        initNavigationBar()
    }

    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if updateSettingTextData() {
            view.endEditing(true)
        }
    }

    @IBAction func changeSettingData(_ sender: UISegmentedControl) {
        updateSettingSegmentData()
    }

    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if updateSettingTextData() {
            view.endEditing(true)
            return true
        } else {
            return false
        }
    }

    private func updateSettingTextData() -> Bool {
        var texts: [TextFieldName: String] = [:]
        for textField in textFields {
            if textField.tag == 0 {
                if Utils.isValidSettingViewText(text: textField, textType: .ipAddress), textField.text != "" {
                    texts[.ipAddress] = textField.text ?? ""
                } else {
                    return false
                }
            } else if textField.tag == 1 {
                if Utils.isValidSettingViewText(text: textField, textType: .portNumber), textField.text != "" {
                    texts[.portNumber] = textField.text ?? ""
                } else {
                    return false
                }
            } else if textField.tag == 2 {
                if Utils.isValidSettingViewText(text: textField, textType: .deviceUuid), textField.text != "" {
                    texts[.uuid] = textField.text ?? ""
                } else {
                    return false
                }
            }
        }

        presenter.updateTextsUserDefault(texts: texts)
        return true
    }

    private func updateSettingSegmentData() {
        var segmentControls: [SegmentName: Int] = [:]
        for segment in segments {
            if segment.tag == 0 {
                segmentControls[.dataDestination] = segment.selectedSegmentIndex
            } else if segment.tag == 1 {
                segmentControls[.dataProtocol] = segment.selectedSegmentIndex
            } else if segment.tag == 2 {
                segmentControls[.messageFormat] = segment.selectedSegmentIndex
            } else if segment.tag == 3 {
                segmentControls[.messageRatePerSecond] = segment.selectedSegmentIndex
            }
        }

        presenter.updateSegmentsUserDefault(segmentControls: segmentControls)
    }

    private func initNavigationBar() {
        guard let navigationController else { return }
        Utils.configureNavigationBar(navigationController.navigationBar)
    }
}

extension CommandSettingViewController: CommandSettingPresenterDelegate {}

extension CommandSettingViewController: UITextFieldDelegate {
    private func setTextFieldSetting(texField: UITextField, text: String) {
        texField.text = String(text)
        texField.delegate = self
        texField.keyboardAppearance = .dark

        if texField.tag == 0 {
            texField.keyboardType = .asciiCapable
        } else if texField.tag == 1 {
            texField.keyboardType = .numberPad
        } else if texField.tag == 2 {
            texField.keyboardType = .asciiCapable
            texField.autocapitalizationType = .none
            texField.autocorrectionType = .no
            texField.spellCheckingType = .no
        }
    }
}

extension CommandSettingViewController: ContentScrollable {
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureObserver()
    }

    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeObserver()
    }

    func configureObserver() {
        showObserver = NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillShowNotification,
            object: nil,
            queue: nil
        ) { [weak self] notification in
            guard let self = self else { return }
            self.keyboardWillShow(notification)
        }
        hideObserver = NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillHideNotification,
            object: nil,
            queue: nil
        ) { [weak self] notification in
            guard let self = self else { return }
            self.keyboardWillHide(notification)
        }
    }

    func removeObserver() {
        NotificationCenter.default.removeObserver(self)
        if let showObserver {
            NotificationCenter.default.removeObserver(showObserver)
        }
        if let hideObserver {
            NotificationCenter.default.removeObserver(hideObserver)
        }
    }

    func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        guard let keyboardSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height else {
            return
        }
        scrollView.contentInset.bottom = keyboardSize
    }

    func keyboardWillHide(_ notification: Notification) {
        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = .zero
    }
}
