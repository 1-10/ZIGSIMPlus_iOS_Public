//
//  CommandDataSettingViewPresenter.swift
//  ZIGSIMPlus
//
//  Created by YoneyamaShunpei on 2019/05/23.
//  Copyright © 2019 Nozomu Kuwae. All rights reserved.
//

import Foundation
import UIKit

public class CommandDataSettingViewPresenter : UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var dataDestinationSeg: UISegmentedControl!
    @IBOutlet weak var protocoloSeg: UISegmentedControl!
    @IBOutlet weak var ipAdressTextField: UITextField!
    @IBOutlet weak var portNumberTextField: UITextField!
    @IBOutlet weak var messageFormatSeg: UISegmentedControl!
    @IBOutlet weak var messageRateSeg: UISegmentedControl!
    @IBOutlet weak var uuidTextField: UITextField!
    @IBOutlet weak var compassAngleSeg: UISegmentedControl!
    @IBOutlet weak var beaconuuid1TextField: UITextField!
    @IBOutlet weak var beaconuuid2TextField: UITextField!
    @IBOutlet weak var beaconuuid3TextField: UITextField!
    @IBOutlet weak var beaconuuid4TextField: UITextField!
    @IBOutlet weak var beaconuuid5TextField: UITextField!
    
    override public func viewDidLoad() {
        super.viewDidLoad()

        // set delegate and editor
        setTextFieldSetting(texField: ipAdressTextField, text: AppSettingModel.userIpAdress)
        setTextFieldSetting(texField: portNumberTextField, text: AppSettingModel.userPortNumber)
        setTextFieldSetting(texField: uuidTextField, text: AppSettingModel.userDeviceUUID)
        setTextFieldSetting(texField: beaconuuid1TextField, text: Utils.separateBeaconUuid(uuid: AppSettingModel.userBeaconUUID, position:0))
        setTextFieldSetting(texField: beaconuuid2TextField, text: Utils.separateBeaconUuid(uuid: AppSettingModel.userBeaconUUID, position:1))
        setTextFieldSetting(texField: beaconuuid3TextField, text: Utils.separateBeaconUuid(uuid: AppSettingModel.userBeaconUUID, position:2))
        setTextFieldSetting(texField: beaconuuid4TextField, text: Utils.separateBeaconUuid(uuid: AppSettingModel.userBeaconUUID, position:3))
        setTextFieldSetting(texField: beaconuuid5TextField, text: Utils.separateBeaconUuid(uuid: AppSettingModel.userBeaconUUID, position:4))
        
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
//        texField.layer.backgroundColor = UIColor.blackColor().CGColor
//        texField.layer.borderColor = SSAppUtility().greenColor().CGColor
        texField.text = String(text)
        texField.layer.borderWidth = 1.0
        texField.delegate = self
    }
    
    override public func viewWillDisappear(_ animated: Bool) {
        
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
        var beaconUUID = beaconuuid1TextField.text!
        beaconUUID += "-"
        beaconUUID += beaconuuid2TextField.text!
        beaconUUID += "-"
        beaconUUID += beaconuuid3TextField.text!
        beaconUUID += "-"
        beaconUUID += beaconuuid4TextField.text!
        beaconUUID += "-"
        beaconUUID += beaconuuid5TextField.text!
        AppSettingModel.shared.beaconUUID = beaconUUID
        AppSettingModel.userBeaconUUID = AppSettingModel.shared.beaconUUID
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
        case beaconuuid1TextField:
            beaconuuid1TextField.resignFirstResponder()
            break
        case beaconuuid2TextField:
            beaconuuid2TextField.resignFirstResponder()
            break
        case beaconuuid3TextField:
            beaconuuid3TextField.resignFirstResponder()
            break
        case beaconuuid4TextField:
            beaconuuid4TextField.resignFirstResponder()
            break
        default:
            break
        }
        
        return true
    }
}
