//
//  CommandSettingViewPresenter.swift
//  ZIGSIMPlus
//
//  Created by YoneyamaShunpei on 2019/05/23.
//  Copyright © 2019 1→10, Inc. All rights reserved.
//
import Foundation
import UIKit
import SVProgressHUD

protocol ContentScrollable {
    var scrollView: UIScrollView! { get }
    func configureObserver()
    func removeObserver()
}

public class CommandSettingViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet var labels: [UILabel]!
    @IBOutlet var segments: [UISegmentedControl]!
    @IBOutlet var textFields: [UITextField]!
    @IBOutlet weak var restorePurchaseButton: UIButton!
    var presenter: CommandSettingPresenterProtocol!

    override public func viewDidLoad() {
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
        }

        initNavigationBar()
        adjustViewDesign()

    }

    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touch screen!")
        if updateSettingTextData() {
            self.view.endEditing(true)
        }
    }

    @IBAction func changeSettingData(_ sender: UISegmentedControl) {
        updateSettingSegmentData()
    }

    @IBAction func restorePurchasePressed(_ sender: UIButton) {
        restorePurchaseButton.isEnabled = false
        SVProgressHUD.show()
        presenter.restorePurchase()
    }

    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("should end editing!")
        if updateSettingTextData() {
            self.view.endEditing(true)
            return true
        } else {
            return false
        }
    }

    private func updateSettingTextData() -> Bool {
        var texts: [textFieldName: String] = [:]
        for textField in textFields {
            if textField.tag == 0 {
                if Utils.isValidSettingViewText(text: textField, textType: .ipAddress) && textField.text != "" {
                    texts[.ipAdress] = textField.text ?? ""
                } else {
                    return false
                }
            } else if textField.tag == 1 {
                if Utils.isValidSettingViewText(text: textField, textType: .portNumber) && textField.text != "" {
                    texts[.portNumber] = textField.text ?? ""
                } else {
                    return false
                }
            } else if textField.tag == 2 {
                if Utils.isValidSettingViewText(text: textField, textType: .deviceUuid) && textField.text != "" {
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
        var segmentControls: [segmentName: Int] = [:]
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

    private func adjustViewDesign() {
        restorePurchaseButton.setTitle(" Restore\nPurchase", for: .normal)
        restorePurchaseButton.setTitleColor(Theme.main, for: .normal)
        restorePurchaseButton.titleLabel?.numberOfLines = 2
        restorePurchaseButton.layer.cornerRadius = 0.5 * restorePurchaseButton.bounds.size.width
        restorePurchaseButton.layer.borderWidth = 1.0
        restorePurchaseButton.layer.borderColor = Theme.main.cgColor
    }
}

extension CommandSettingViewController: CommandSettingPresenterDelegate {
    func showRestorePurchaseResult(isSuccessful: Bool, title: String?, message: String?) {
        SVProgressHUD.dismiss()

        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Close", style: .default) { _ in
            self.restorePurchaseButton.isEnabled = true
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}

extension CommandSettingViewController: UITextFieldDelegate {
    private func setTextFieldSetting(texField: UITextField, text: String) {
        texField.text = String(text)
        texField.delegate = self
    }
}

extension CommandSettingViewController: ContentScrollable {
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureObserver()
    }

    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeObserver()
    }

    func configureObserver() {
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: nil) { notification in
            self.keyboardWillShow(notification)
        }
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: nil) { notification in
            self.keyboardWillHide(notification)
        }
    }

    func removeObserver() {
        NotificationCenter.default.removeObserver(self)
    }

    func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        let keyboardSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height
        scrollView.contentInset.bottom = keyboardSize
    }

    func keyboardWillHide(_ notification: Notification) {
        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = .zero
    }
}
