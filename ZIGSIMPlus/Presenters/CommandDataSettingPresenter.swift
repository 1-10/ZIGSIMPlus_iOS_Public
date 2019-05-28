//
//  CommandDataSettingPresenter.swift
//  ZIGSIMPlus
//
//  Created by YoneyamaShunpei on 2019/05/28.
//  Copyright © 2019 Nozomu Kuwae. All rights reserved.
//

import Foundation
import UIKit
import SwiftyUserDefaults

protocol CommandDataSettingPresenterProtocol {
    func initUserDefalut(view: UIView, scrollView: UIScrollView, textFilds: Array<Any>, segmentFilds: Array<Any>)
    func beaconUuidValidate()
    func setUserDefault()
}

protocol CommandDataSettingPresenterDelegate: AnyObject {
    func setDelegate(texField:UITextField)
}

final class CommandDataSettingPresenter: CommandDataSettingPresenterProtocol {
    var view: CommandDataSettingPresenterDelegate!
    var settingView: UIView!
    var dataDestinationSeg: UISegmentedControl!
    var protocoloSeg: UISegmentedControl!
    var messageFormatSeg: UISegmentedControl!
    var messageRateSeg: UISegmentedControl!
    var compassAngleSeg: UISegmentedControl!
    var ipAdressTextField: UITextField!
    var portNumberTextField: UITextField!
    var uuidTextField: UITextField!
    var beaconUUID1TextField: UITextField!
    var beaconUUID2TextField: UITextField!
    var beaconUUID3TextField: UITextField!
    var beaconUUID4TextField: UITextField!
    var beaconUUID5TextField: UITextField!
    
    func initUserDefalut(view: UIView, scrollView: UIScrollView, textFilds: Array<Any>, segmentFilds: Array<Any>) {
        // set view
        settingView = view
        
        // set scrollView
        let mainBoundSize: CGSize = UIScreen.main.bounds.size
        scrollView.contentSize = CGSize(width: mainBoundSize.width, height: mainBoundSize.height)
        view.addSubview(scrollView)
        
        // set delegate and editor
        ipAdressTextField    = (textFilds[0] as! UITextField)
        portNumberTextField  = (textFilds[1] as! UITextField)
        uuidTextField        = (textFilds[2] as! UITextField)
        beaconUUID1TextField = (textFilds[3] as! UITextField)
        beaconUUID2TextField = (textFilds[4] as! UITextField)
        beaconUUID3TextField = (textFilds[5] as! UITextField)
        beaconUUID4TextField = (textFilds[6] as! UITextField)
        beaconUUID5TextField = (textFilds[7] as! UITextField)
        setTextFieldSetting(texField: ipAdressTextField, text: Defaults[.userIpAdress]!.description)
        setTextFieldSetting(texField: portNumberTextField, text: Defaults[.userPortNumber]!.description)
        setTextFieldSetting(texField: uuidTextField, text: Defaults[.userDeviceUUID]!.description)
        setTextFieldSetting(texField: beaconUUID1TextField, text: Utils.separateBeaconUuid(uuid: Defaults[.userBeaconUUID]!.description, position:0))
        setTextFieldSetting(texField: beaconUUID2TextField, text: Utils.separateBeaconUuid(uuid: Defaults[.userBeaconUUID]!.description, position:1))
        setTextFieldSetting(texField: beaconUUID3TextField, text: Utils.separateBeaconUuid(uuid: Defaults[.userBeaconUUID]!.description, position:2))
        setTextFieldSetting(texField: beaconUUID4TextField, text: Utils.separateBeaconUuid(uuid: Defaults[.userBeaconUUID]!.description, position:3))
        setTextFieldSetting(texField: beaconUUID5TextField, text: Utils.separateBeaconUuid(uuid: Defaults[.userBeaconUUID]!.description, position:4))
        
        // set segmented control
        dataDestinationSeg = (segmentFilds[0] as! UISegmentedControl)
        protocoloSeg       = (segmentFilds[1] as! UISegmentedControl)
        messageFormatSeg   = (segmentFilds[2] as! UISegmentedControl)
        messageRateSeg     = (segmentFilds[3] as! UISegmentedControl)
        compassAngleSeg    = (segmentFilds[4] as! UISegmentedControl)
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
    
    func beaconUuidValidate(){
        
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
            self.settingView.endEditing(true)
        }
        
    }
    
    func setUserDefault(){
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
        self.view.setDelegate(texField: texField)
    }
    
}
