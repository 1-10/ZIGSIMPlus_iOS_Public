//
//  CommandSettingViewPresenter.swift
//  ZIGSIMPlus
//
//  Created by YoneyamaShunpei on 2019/05/23.
//  Copyright © 2019 Nozomu Kuwae. All rights reserved.
//
import Foundation
import UIKit
import SVProgressHUD

protocol ContentScrollable {
    var scrollView: UIScrollView! { get }
    func configureObserver()
    func removeObserver()
}

public class CommandSettingViewController : UIViewController {
    
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
        updateSettingData()
        self.view.endEditing(true)
    }
    
    @IBAction func changeSettingData(_ sender: UISegmentedControl) {
        updateSettingData()
    }
    
    @IBAction func restorePurchasePressed(_ sender: UIButton) {
        restorePurchaseButton.isEnabled = false
        SVProgressHUD.show()
        presenter.restorePurchase()
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        print("should end editing!")
        updateSettingData()
        self.view.endEditing(true)
        return true
    }
    
    private func updateSettingData() {
        var texts:[textFieldName: String] = [:]
        for textField in textFields {
            if textField.tag == 0 {
                texts[.ipAdress] = textField.text ?? ""
            } else if textField.tag == 1 {
                texts[.portNumber] = textField.text ?? ""
            } else if textField.tag == 2 {
                texts[.uuid] = textField.text ?? ""
            }
        }
        presenter.updateTextsUserDefault(texts:texts)
    
        var segmentControls:[segmentName:Int] = [:]
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
        let titleImage = UIImage(named: "Logo")
        let titleImageView = UIImageView(image: titleImage)
        titleImageView.contentMode = .scaleAspectFit
        navigationItem.titleView = titleImageView
        navigationController?.navigationBar.barTintColor = UIColor(displayP3Red: 33/255, green: 33/255, blue: 33/255, alpha: 1.0)
        
        let backButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backButtonItem
        navigationController?.navigationBar.tintColor = UIColor(displayP3Red: 0, green: 161/255, blue: 101/255, alpha: 1.0)
        
        let infoButton: UIButton = navigationItem.rightBarButtonItem?.customView as! UIButton
        infoButton.layer.cornerRadius = 0.5 * infoButton.bounds.size.width
        infoButton.layer.borderWidth = 1.0
        infoButton.layer.borderColor = UIColor(displayP3Red: 103/255, green: 103/255, blue: 103/255, alpha: 1.0).cgColor
        infoButton.backgroundColor = UIColor(displayP3Red: 103/255, green: 103/255, blue: 103/255, alpha: 1.0)
    }
    
    private func adjustViewDesign() {
        for label in labels {
            adjustLabelDesign(label: label)
        }
        
        for segment in segments {
            adjustSegmentDesign(segment: segment)
        }
        
        for textField in textFields {
            adjustTextFieldDesign(textField: textField)
        }
        
        adjustButtonDesign()
    }
    
    private func adjustLabelDesign(label: UILabel) {
        label.textColor = UIColor(displayP3Red: 0, green: 161/255, blue: 101/255, alpha: 1.0)
    }
    
    private func adjustSegmentDesign(segment: UISegmentedControl) {
        segment.tintColor = UIColor(displayP3Red: 0, green: 161/255, blue: 101/255, alpha: 1.0)
        segment.layer.backgroundColor = UIColor(displayP3Red: 13/255, green: 13/255, blue: 13/255, alpha: 1.0).cgColor
        segment.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.white], for: .selected)
    }
    
    private func adjustTextFieldDesign(textField: UITextField) {
        textField.textColor = UIColor(displayP3Red: 0, green: 161/255, blue: 101/255, alpha: 1.0)
        textField.backgroundColor =  UIColor(displayP3Red: 13/255, green: 13/255, blue: 13/255, alpha: 1.0)
        textField.layer.borderWidth = 1.0
        textField.layer.cornerRadius = 4.0
        textField.layer.borderColor = UIColor(displayP3Red: 0, green: 161/255, blue: 101/255, alpha: 1.0).cgColor
    }
    
    private func adjustButtonDesign() {
        restorePurchaseButton.setTitle(" Restore\nPurchase", for: .normal)
        restorePurchaseButton.setTitleColor(UIColor(displayP3Red: 0, green: 161/255, blue: 101/255, alpha: 1.0), for: .normal)
        restorePurchaseButton.titleLabel?.numberOfLines = 2
        restorePurchaseButton.layer.cornerRadius = 0.5 * restorePurchaseButton.bounds.size.width
        restorePurchaseButton.layer.borderWidth = 1.0
        restorePurchaseButton.layer.borderColor = UIColor(displayP3Red: 0, green: 161/255, blue: 101/255, alpha: 1.0).cgColor
    }
}

extension CommandSettingViewController: CommandSettingPresenterDelegate {
    func showRestorePurchaseResult(title: String?, message: String?) {
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
    private func setTextFieldSetting(texField:UITextField, text:String) {
        texField.text = String(text)
        texField.delegate = self
    }
}

extension CommandSettingViewController: ContentScrollable{
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
