//
//  CommandDataSettingViewPresenter.swift
//  ZIGSIMPlus
//
//  Created by YoneyamaShunpei on 2019/05/23.
//  Copyright © 2019 Nozomu Kuwae. All rights reserved.
//

import Foundation
import UIKit
import SwiftyUserDefaults

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
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        // set scrollView
        let mainBoundSize: CGSize = UIScreen.main.bounds.size
        self.scrollView.contentSize = CGSize(width: mainBoundSize.width, height: mainBoundSize.height)
        self.view.addSubview(self.scrollView)

        // set delegate and editor
        setTextFieldSetting(texField: ipAdressTextField, text: Defaults[.userIpAdress]!.description)
        setTextFieldSetting(texField: portNumberTextField, text: Defaults[.userPortNumber]!.description)
        setTextFieldSetting(texField: uuidTextField, text: Defaults[.userDeviceUUID]!.description)
        setTextFieldSetting(texField: beaconUUID1TextField, text: Utils.separateBeaconUuid(uuid: Defaults[.userBeaconUUID]!.description, position:0))
        setTextFieldSetting(texField: beaconUUID2TextField, text: Utils.separateBeaconUuid(uuid: Defaults[.userBeaconUUID]!.description, position:1))
        setTextFieldSetting(texField: beaconUUID3TextField, text: Utils.separateBeaconUuid(uuid: Defaults[.userBeaconUUID]!.description, position:2))
        setTextFieldSetting(texField: beaconUUID4TextField, text: Utils.separateBeaconUuid(uuid: Defaults[.userBeaconUUID]!.description, position:3))
        setTextFieldSetting(texField: beaconUUID5TextField, text: Utils.separateBeaconUuid(uuid: Defaults[.userBeaconUUID]!.description, position:4))
        
        // set segmented control
        if Defaults[.userDataDestination] == 0 {
            dataDestinationSeg.selectedSegmentIndex = 0
        } else if Defaults[.userDataDestination] == 1 {
            dataDestinationSeg.selectedSegmentIndex = 1
        }
        if Defaults[.userProtocol] == 0 {
            protocoloSeg.selectedSegmentIndex = 0
        } else if Defaults[.userProtocol] == 1 {
            protocoloSeg.selectedSegmentIndex = 1
        }
        if Defaults[.userMessageFormat] == 0 {
            messageFormatSeg.selectedSegmentIndex = 0
        } else if Defaults[.userMessageFormat] == 1 {
            messageFormatSeg.selectedSegmentIndex = 1
        }
        if  Defaults[.userMessageRatePerSecond] == 1 {
            messageRateSeg.selectedSegmentIndex = 0
        } else if Defaults[.userMessageRatePerSecond] == 10 {
            messageRateSeg.selectedSegmentIndex = 1
        } else if Defaults[.userMessageRatePerSecond] == 30 {
            messageRateSeg.selectedSegmentIndex = 2
        } else if Defaults[.userMessageRatePerSecond] == 60 {
            messageRateSeg.selectedSegmentIndex = 3
        }
        if Defaults[.userCompassAngle] == 0.0 {
            compassAngleSeg.selectedSegmentIndex = 0
        } else if Defaults[.userCompassAngle] == 1.0 {
            compassAngleSeg.selectedSegmentIndex = 1
        }
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureObserver()
    }
    
    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeObserver()
        
        // set DATA DESTINATION
        if dataDestinationSeg.selectedSegmentIndex == 0 {
            AppSettingModel.shared.dataDestination = .LOCAL_FILE
            Defaults[.userDataDestination] = 0
        } else if dataDestinationSeg.selectedSegmentIndex == 1 {
            AppSettingModel.shared.dataDestination = .OTHER_APP
            Defaults[.userDataDestination] = 1
        }
        
        // set PROTOCOL
        if protocoloSeg.selectedSegmentIndex == 0 {
            AppSettingModel.shared.transportProtocol = .UDP
            Defaults[.userProtocol] = 0
        } else if protocoloSeg.selectedSegmentIndex == 1 {
            AppSettingModel.shared.transportProtocol = .TCP
            Defaults[.userProtocol] = 1
        }
        
        // set IP ADDRESS
        AppSettingModel.shared.address = ipAdressTextField.text!
        Defaults[.userIpAdress] = AppSettingModel.shared.address
        
        // set PORT NUMBER
        AppSettingModel.shared.port = Int32(portNumberTextField.text!)!
        Defaults[.userPortNumber] = Int(AppSettingModel.shared.port)
        
        // set MESSAGE FORMAT
        if messageFormatSeg.selectedSegmentIndex == 0 {
            AppSettingModel.shared.transportFormat = .JSON
            Defaults[.userMessageFormat] = 0
        } else if messageFormatSeg.selectedSegmentIndex == 1 {
            AppSettingModel.shared.transportFormat = .OSC
            Defaults[.userMessageFormat] = 1
        }
        
        // set MESSAGE RATE(PER SEC)
        if  messageRateSeg.selectedSegmentIndex == 0 {
            AppSettingModel.shared.messageRatePerSecond = 1
        } else if  messageRateSeg.selectedSegmentIndex == 1 {
            AppSettingModel.shared.messageRatePerSecond = 10
        } else if  messageRateSeg.selectedSegmentIndex == 2 {
            AppSettingModel.shared.messageRatePerSecond = 30
        } else if  messageRateSeg.selectedSegmentIndex == 3 {
            AppSettingModel.shared.messageRatePerSecond = 60
        }
        Defaults[.userMessageRatePerSecond] = AppSettingModel.shared.messageRatePerSecond
        
        // set DEVICE UUID
        AppSettingModel.shared.deviceUUID = uuidTextField.text!
        Defaults[.userDeviceUUID] = AppSettingModel.shared.deviceUUID
        
        // set COMPASS ANGLE
        if compassAngleSeg.selectedSegmentIndex == 0 {
            AppSettingModel.shared.compassAngle = 0.0
        } else if compassAngleSeg.selectedSegmentIndex == 1 {
            AppSettingModel.shared.compassAngle = 1.0
        }
        Defaults[.userCompassAngle] = AppSettingModel.shared.compassAngle
        
        // set BEACON UUID
        var beaconUUID = beaconUUID1TextField.text!
        beaconUUID += "-"
        beaconUUID += beaconUUID2TextField.text!
        beaconUUID += "-"
        beaconUUID += beaconUUID3TextField.text!
        beaconUUID += "-"
        beaconUUID += beaconUUID4TextField.text!
        beaconUUID += "-"
        beaconUUID += beaconUUID5TextField.text!
        AppSettingModel.shared.beaconUUID = beaconUUID
        Defaults[.userBeaconUUID] = AppSettingModel.shared.beaconUUID
    }
    
    public func setTextFieldSetting(texField:UITextField, text:String) {
        texField.text = String(text)
        texField.delegate = self
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        print("should end editing!")

        if (beaconUUID1TextField.text!.count != 8) {
            beaconUUID1TextField.becomeFirstResponder()
        } else if (beaconUUID2TextField.text!.count != 4){
            beaconUUID2TextField.becomeFirstResponder()
        } else if (beaconUUID3TextField.text!.count != 4){
            beaconUUID3TextField.becomeFirstResponder()
        } else if (beaconUUID4TextField.text!.count != 4){
            beaconUUID4TextField.becomeFirstResponder()
        } else if (beaconUUID5TextField.text!.count != 12){
            beaconUUID5TextField.becomeFirstResponder()
        } else {
            view.endEditing(true)
        }
        
        return true
    }
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (beaconUUID1TextField.text!.count != 8) {
            beaconUUID1TextField.becomeFirstResponder()
        } else if (beaconUUID2TextField.text!.count != 4){
            beaconUUID2TextField.becomeFirstResponder()
        } else if (beaconUUID3TextField.text!.count != 4){
            beaconUUID3TextField.becomeFirstResponder()
        } else if (beaconUUID4TextField.text!.count != 4){
            beaconUUID4TextField.becomeFirstResponder()
        } else if (beaconUUID5TextField.text!.count != 12){
            beaconUUID5TextField.becomeFirstResponder()
        } else {
            view.endEditing(true)
        }
    }
}

// Scroll processing
protocol ContentScrollable {
    
    var scrollView: UIScrollView! { get }
    // set Notification
    func configureObserver()
    // delete Notification
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

// Character limit
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
