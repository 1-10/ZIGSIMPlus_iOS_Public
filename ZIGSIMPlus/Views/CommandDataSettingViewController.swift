//
//  CommandDataSettingViewPresenter.swift
//  ZIGSIMPlus
//
//  Created by YoneyamaShunpei on 2019/05/23.
//  Copyright © 2019 Nozomu Kuwae. All rights reserved.
//

import Foundation
import UIKit

public class CommandDataSettingViewController : UIViewController, UITextFieldDelegate, ContentScrollable{
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var dataDestinationSeg: UISegmentedControl!
    @IBOutlet weak var protocoloSeg: UISegmentedControl!
    @IBOutlet weak var ipAdressTextField: UITextField!
    @IBOutlet weak var portNumberTextField: UITextField!
    @IBOutlet weak var messageFormatSeg: UISegmentedControl!
    @IBOutlet weak var messageRateSeg: UISegmentedControl!
    @IBOutlet weak var uuidTextField: UITextField!
    @IBOutlet weak var compassAngleSeg: UISegmentedControl!
    @IBOutlet weak var beaconUUID1TextField: UITextField!
    @IBOutlet weak var beaconUUID2TextField: UITextField!
    @IBOutlet weak var beaconUUID3TextField: UITextField!
    @IBOutlet weak var beaconUUID4TextField: UITextField!
    @IBOutlet weak var beaconUUID5TextField: UITextField!
    var presenter: CommandDataSettingPresenterProtocol!
   
    override public func viewDidLoad() {
        super.viewDidLoad()
        let UITexts = [
            ipAdressTextField,
            portNumberTextField,
            uuidTextField,
            beaconUUID1TextField,
            beaconUUID2TextField,
            beaconUUID3TextField,
            beaconUUID4TextField,
            beaconUUID5TextField
        ]
        let UISegments = [
            dataDestinationSeg,
            protocoloSeg,
            messageFormatSeg,
            messageRateSeg,
            compassAngleSeg
        ]
        presenter.initUserDefalut(view: self.view, scrollView: self.scrollView, textFilds: UITexts as Array<Any>, segmentFilds: UISegments as Array<Any>)
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureObserver()
    }
    
    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeObserver()
        presenter.setUserDefault()
    }
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        presenter.validate()
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        print("should end editing!")
        presenter.validate()
        return true
    }
}

extension CommandDataSettingViewController: CommandDataSettingPresenterDelegate {
    public func setDelegate(texField:UITextField) {
        texField.delegate = self
    }
}

// Processing of Scroll view
protocol ContentScrollable {
    var scrollView: UIScrollView! { get }
    func configureObserver()
    func removeObserver()
}

extension ContentScrollable where Self: UIViewController {
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

extension UIScrollView {
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.next?.touchesBegan(touches, with: event)
    }
}

// Limit of Character input number
private var maxLengths = [UITextField: Int]()
extension UITextField {
    
    @IBInspectable var maxLength: Int {
        get {
            guard let length = maxLengths[self] else {
                return Int.max
            }
            
            return length
        }
        set {
            maxLengths[self] = newValue
            addTarget(self, action: #selector(limitLength), for: .editingChanged)
        }
    }
    
    @objc func limitLength(textField: UITextField) {
        guard let prospectiveText = textField.text, prospectiveText.count > maxLength else {
            return
        }
        
        let selection = selectedTextRange
        let maxCharIndex = prospectiveText.index(prospectiveText.startIndex, offsetBy: maxLength)
        
        #if swift(>=4.0)
        text = String(prospectiveText[..<maxCharIndex])
        #else
        text = prospectiveText.substring(to: maxCharIndex)
        #endif
        
        selectedTextRange = selection
    }
}
