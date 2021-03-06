//
//  CommandSettingViewPresenter.swift
//  ZIGSIMPlus
//
//  Created by YoneyamaShunpei on 2019/05/23.
//  Copyright © 2019 1→10, Inc. All rights reserved.
//
import Foundation
import SVProgressHUD
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
                setTextFieldSetting(texField: textField, text: userDefaultTexts[.ipAdress]?.description ?? "")
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
            if #available(iOS 13.0, *) {
                segment.selectedSegmentTintColor = Theme.main
                segment.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: Theme.main], for: .normal)
                segment.layer.borderWidth = 1
                segment.layer.borderColor = Theme.main.cgColor
            }
        }

        initNavigationBar()
    }

    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touch screen!")
        if updateSettingTextData() {
            view.endEditing(true)
        }
    }

    @IBAction func changeSettingData(_ sender: UISegmentedControl) {
        updateSettingSegmentData()
    }

    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("should end editing!")
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
                    texts[.ipAdress] = textField.text ?? ""
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
        Utils.setTitleImage(navigationController!.navigationBar)
        navigationController?.navigationBar.barTintColor = Theme.dark
        navigationController?.navigationBar.tintColor = Theme.main
    }
}

extension CommandSettingViewController: CommandSettingPresenterDelegate {}

extension CommandSettingViewController: UITextFieldDelegate {
    private func setTextFieldSetting(texField: UITextField, text: String) {
        texField.text = String(text)
        texField.delegate = self
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
        ) { notification in
            self.keyboardWillShow(notification)
        }
        hideObserver = NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillHideNotification,
            object: nil,
            queue: nil
        ) { notification in
            self.keyboardWillHide(notification)
        }
    }

    func removeObserver() {
        NotificationCenter.default.removeObserver(self)
        if showObserver != nil { NotificationCenter.default.removeObserver(showObserver! as Any) }
        if hideObserver != nil { NotificationCenter.default.removeObserver(hideObserver! as Any) }
    }

    func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        // swiftlint:disable:next force_cast
        let keyboardSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height
        scrollView.contentInset.bottom = keyboardSize
    }

    func keyboardWillHide(_ notification: Notification) {
        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = .zero
    }
}
