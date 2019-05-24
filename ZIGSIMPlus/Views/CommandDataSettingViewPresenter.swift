//
//  CommandDataSettingViewPresenter.swift
//  ZIGSIMPlus
//
//  Created by YoneyamaShunpei on 2019/05/23.
//  Copyright © 2019 Nozomu Kuwae. All rights reserved.
//

import Foundation
import UIKit

public class CommandDataSettingViewPresenter : UIViewController, UITextFieldDelegate, ContentScrollable{
    
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
        setTextFieldSetting(texField: ipAdressTextField, text: AppSettingModel.userIpAdress)
        setTextFieldSetting(texField: portNumberTextField, text: AppSettingModel.userPortNumber)
        setTextFieldSetting(texField: uuidTextField, text: AppSettingModel.userDeviceUUID)
        setTextFieldSetting(texField: beaconUUID1TextField, text: Utils.separateBeaconUuid(uuid: AppSettingModel.userBeaconUUID, position:0))
        setTextFieldSetting(texField: beaconUUID2TextField, text: Utils.separateBeaconUuid(uuid: AppSettingModel.userBeaconUUID, position:1))
        setTextFieldSetting(texField: beaconUUID3TextField, text: Utils.separateBeaconUuid(uuid: AppSettingModel.userBeaconUUID, position:2))
        setTextFieldSetting(texField: beaconUUID4TextField, text: Utils.separateBeaconUuid(uuid: AppSettingModel.userBeaconUUID, position:3))
        setTextFieldSetting(texField: beaconUUID5TextField, text: Utils.separateBeaconUuid(uuid: AppSettingModel.userBeaconUUID, position:4))
        
        // set segment
        if AppSettingModel.userDataDestination == "LOCAL_FILE" {
            dataDestinationSeg.selectedSegmentIndex = 0
        } else if AppSettingModel.userDataDestination == "OTHER_APP" {
            dataDestinationSeg.selectedSegmentIndex = 1
        }
        if AppSettingModel.userProtocolo == "UDP" {
            protocoloSeg.selectedSegmentIndex = 0
        } else if AppSettingModel.userProtocolo == "TCP" {
            protocoloSeg.selectedSegmentIndex = 1
        }
        if AppSettingModel.userMessageFormat == "JSON" {
            messageFormatSeg.selectedSegmentIndex = 0
        } else if AppSettingModel.userMessageFormat == "OSC" {
            messageFormatSeg.selectedSegmentIndex = 1
        }
        if  AppSettingModel.userMessageRatePerSecond == 1 {
            messageRateSeg.selectedSegmentIndex = 0
        } else if  AppSettingModel.userMessageRatePerSecond == 10 {
            messageRateSeg.selectedSegmentIndex = 1
        } else if  AppSettingModel.userMessageRatePerSecond == 30 {
            messageRateSeg.selectedSegmentIndex = 2
        } else if  AppSettingModel.userMessageRatePerSecond == 60 {
            messageRateSeg.selectedSegmentIndex = 3
        }
        if AppSettingModel.userCompassAngle == 0.0 {
            compassAngleSeg.selectedSegmentIndex = 0
        } else if AppSettingModel.userCompassAngle == 1.0 {
            compassAngleSeg.selectedSegmentIndex = 1
        }
    }
    
    public func setTextFieldSetting(texField:UITextField, text:String) {
        texField.text = String(text)
        texField.delegate = self
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureObserver()
    }
    
    override public func viewWillDisappear(_ animated: Bool) {
        
        removeObserver()
        
        // DATA DESTINATION
        if dataDestinationSeg.selectedSegmentIndex == 0 {
            AppSettingModel.shared.dataDestination = "LOCAL_FILE"
            AppSettingModel.userDataDestination = AppSettingModel.shared.dataDestination
        } else if dataDestinationSeg.selectedSegmentIndex == 1 {
            AppSettingModel.shared.dataDestination = "OTHER_APP"
            AppSettingModel.userDataDestination = AppSettingModel.shared.dataDestination
        }
        
        // PROTOCOL
        if protocoloSeg.selectedSegmentIndex == 0 {
            AppSettingModel.shared.protocolo = "UDP"
            AppSettingModel.userProtocolo = AppSettingModel.shared.protocolo
        } else if protocoloSeg.selectedSegmentIndex == 1 {
            AppSettingModel.shared.protocolo = "TCP"
            AppSettingModel.userProtocolo = AppSettingModel.shared.protocolo
        }
        
        // IP ADDRESS
        AppSettingModel.shared.ipAdress = ipAdressTextField.text!
        AppSettingModel.userIpAdress = AppSettingModel.shared.ipAdress
        
        // PORT NUMBER
        AppSettingModel.shared.portNumber = portNumberTextField.text!
        AppSettingModel.userPortNumber = AppSettingModel.shared.portNumber
        
        // MESSAGE FORMAT
        if messageFormatSeg.selectedSegmentIndex == 0 {
            AppSettingModel.shared.messageFormat = "JSON"
            AppSettingModel.userMessageFormat = AppSettingModel.shared.messageFormat
        } else if messageFormatSeg.selectedSegmentIndex == 1 {
           AppSettingModel.shared.messageFormat = "OSC"
           AppSettingModel.userMessageFormat = AppSettingModel.shared.messageFormat
        }
        
        // MESSAGE RATE(PER SEC)
        if  messageRateSeg.selectedSegmentIndex == 0 {
            AppSettingModel.shared.messageRatePerSecond = 1
            AppSettingModel.userMessageRatePerSecond = AppSettingModel.shared.messageRatePerSecond
        } else if  messageRateSeg.selectedSegmentIndex == 1 {
            AppSettingModel.shared.messageRatePerSecond = 10
            AppSettingModel.userMessageRatePerSecond = AppSettingModel.shared.messageRatePerSecond
        } else if  messageRateSeg.selectedSegmentIndex == 2 {
            AppSettingModel.shared.messageRatePerSecond = 30
            AppSettingModel.userMessageRatePerSecond = AppSettingModel.shared.messageRatePerSecond
        } else if  messageRateSeg.selectedSegmentIndex == 3 {
            AppSettingModel.shared.messageRatePerSecond = 60
            AppSettingModel.userMessageRatePerSecond = AppSettingModel.shared.messageRatePerSecond
        }
        
        // DEVICE UUID
        AppSettingModel.shared.deviceUUID = uuidTextField.text!
        AppSettingModel.userDeviceUUID = AppSettingModel.shared.deviceUUID
        
        // COMPASS ANGLE
        if compassAngleSeg.selectedSegmentIndex == 0 {
            AppSettingModel.shared.compassAngle = 0.0
            AppSettingModel.userCompassAngle = AppSettingModel.shared.compassAngle
        } else if compassAngleSeg.selectedSegmentIndex == 1 {
            AppSettingModel.shared.compassAngle = 1.0
            AppSettingModel.userCompassAngle = AppSettingModel.shared.compassAngle
        }
        
        // BEACON UUID
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
        AppSettingModel.userBeaconUUID = AppSettingModel.shared.beaconUUID
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        print("end editing!")
    }
    
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        print("start editing!")
        return true
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        print("should end editing!")
        // close keyboard
        switch textField {
        case ipAdressTextField:
            ipAdressTextField.resignFirstResponder()
            break
        case portNumberTextField:
            portNumberTextField.resignFirstResponder()
            break
        case uuidTextField:
            uuidTextField.resignFirstResponder()
            break
        case beaconUUID1TextField:
            beaconUUID1TextField.resignFirstResponder()
            break
        case beaconUUID2TextField:
            beaconUUID2TextField.resignFirstResponder()
            break
        case beaconUUID3TextField:
            beaconUUID3TextField.resignFirstResponder()
            break
        case beaconUUID4TextField:
            beaconUUID4TextField.resignFirstResponder()
            break
        case beaconUUID5TextField:
            beaconUUID5TextField.resignFirstResponder()
            break
        default:
            break
        }
        
        return true
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
