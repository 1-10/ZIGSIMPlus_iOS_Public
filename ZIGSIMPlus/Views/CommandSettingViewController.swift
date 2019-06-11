//
//  CommandSettingViewPresenter.swift
//  ZIGSIMPlus
//
//  Created by YoneyamaShunpei on 2019/05/23.
//  Copyright © 2019 Nozomu Kuwae. All rights reserved.
//
import Foundation
import UIKit

protocol ContentScrollable {
    var scrollView: UIScrollView! { get }
    func configureObserver()
    func removeObserver()
}

public class CommandSettingViewController : UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var dataDestinationSeg: UISegmentedControl!
    @IBOutlet weak var protocoloSeg: UISegmentedControl!
    @IBOutlet weak var ipAdressTextField: UITextField!
    @IBOutlet weak var portNumberTextField: UITextField!
    @IBOutlet weak var messageFormatSeg: UISegmentedControl!
    @IBOutlet weak var messageRateSeg: UISegmentedControl!
    @IBOutlet weak var uuidTextField: UITextField!
    @IBOutlet weak var compassAngleSeg: UISegmentedControl!
    @IBOutlet var beaconUUIDTextFilds: [UITextField]!
    
    var presenter: CommandSettingPresenterProtocol!
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        let userDefaultTexts = presenter.getUserDefaultTexts()
        setTextFieldSetting(texField: ipAdressTextField, text: userDefaultTexts["ipAdress"]?.description ?? "")
        setTextFieldSetting(texField: portNumberTextField, text: userDefaultTexts["portNumber"]?.description ?? "")
        setTextFieldSetting(texField: uuidTextField, text: userDefaultTexts["uuid"]?.description ?? "")
        for  beaconUUIDTextFild in beaconUUIDTextFilds {
            let beaconUUID = "beaconUUID" + String(beaconUUIDTextFild.tag)
            setTextFieldSetting(texField: beaconUUIDTextFild, text: userDefaultTexts[beaconUUID]?.description ?? "")
        }
        
        let userDefaultSegments = presenter.getUserDefaultSegments()
        dataDestinationSeg.selectedSegmentIndex = userDefaultSegments["userDataDestination"] ?? 0
        protocoloSeg.selectedSegmentIndex = userDefaultSegments["userProtocol"] ?? 0
        messageFormatSeg.selectedSegmentIndex = userDefaultSegments["userMessageFormat"] ?? 0
        messageRateSeg.selectedSegmentIndex = userDefaultSegments["userMessageRatePerSecond"] ?? 0
        compassAngleSeg.selectedSegmentIndex = userDefaultSegments["userCompassAngle"] ?? 0
        
    }
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touch screen!")
        beaconUuidValidate()
    }
    
    @IBAction func changeSettingData(_ sender: UISegmentedControl) {
        updateSettingData()
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        print("should end editing!")
        beaconUuidValidate()
        return true
    }
    
    private func updateSettingData() {
        var texts:[String:String] = [
            "ipAdress": ipAdressTextField.text ?? "",
            "portNumber": portNumberTextField.text ?? "",
            "uuid": uuidTextField.text ?? "",
        ]
        
        for beaconUUIDTextFild in beaconUUIDTextFilds {
            let beaconUUID = "beaconUUID" + String(beaconUUIDTextFild.tag)
            texts[beaconUUID] = beaconUUIDTextFild.text ?? ""
        }
        presenter.updateTextsUserDefault(texts:texts)
    
        let segmentControls:[String:Int] = [
            "userDataDestination": dataDestinationSeg.selectedSegmentIndex,
            "userProtocol": protocoloSeg.selectedSegmentIndex,
            "userMessageFormat": messageFormatSeg.selectedSegmentIndex,
            "userMessageRatePerSecond": messageRateSeg.selectedSegmentIndex,
            "userCompassAngle":compassAngleSeg.selectedSegmentIndex
        ]
        presenter.updateSegmentsUserDefault(segmentControls: segmentControls)
    }
    
    private func beaconUuidValidate(){
        
        let validataNumbers = [8,4,4,4,12]
        var updateUUID = false
        for beaconUUIDTextFild in beaconUUIDTextFilds {
            let beaconUUID = beaconUUIDTextFild.tag
            if 1 <= beaconUUID && beaconUUID <= 5 && (beaconUUIDTextFild.text?.description ?? "").count != validataNumbers[beaconUUID - 1] {
                updateUUID = false
                beaconUUIDTextFild.becomeFirstResponder()
                break
            } else {
                updateUUID = true
            }
        }
        
        if updateUUID == true {
            updateSettingData()
            self.view.endEditing(true)
        }
    }
}

extension CommandSettingViewController: CommandSettingPresenterDelegate {}

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
