//
//  CommandDataSettingViewPresenter.swift
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

public class CommandDataSettingViewController : UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var dataDestinationSeg: UISegmentedControl!
    @IBOutlet weak var protocoloSeg: UISegmentedControl!
    @IBOutlet weak var ipAdressTextField: UITextField!
    @IBOutlet weak var portNumberTextField: UITextField!
    @IBOutlet weak var messageFormatSeg: UISegmentedControl!
    @IBOutlet weak var messageRateSeg: UISegmentedControl!
    @IBOutlet weak var uuidTextField: UITextField!
    @IBOutlet weak var compassAngleSeg: UISegmentedControl!
    @IBOutlet var beaconUUIDTextFields: [UITextField]!
    
    var presenter: CommandDataSettingPresenterProtocol!
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        let userDefaultTexts = presenter.getUserDefaultTexts()
        setTextFieldSetting(texField: ipAdressTextField, text: userDefaultTexts["ipAdress"]?.description ?? "")
        setTextFieldSetting(texField: portNumberTextField, text: userDefaultTexts["portNumber"]?.description ?? "")
        setTextFieldSetting(texField: uuidTextField, text: userDefaultTexts["uuid"]?.description ?? "")
        for i in 0 ..< beaconUUIDTextFields.count {
            var beaconId = "beaconUUID"
            beaconId = beaconId + String(i + 1)
            setTextFieldSetting(texField: beaconUUIDTextFields[i], text: userDefaultTexts[beaconId]?.description ?? "")
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
    
    @IBAction func changeDataDestination(_ sender: Any) {
        updateSettingData()
    }
    
    @IBAction func changeProtocol(_ sender: Any) {
        updateSettingData()
    }
    
    @IBAction func changeMessageFormat(_ sender: Any) {
        updateSettingData()
    }
    
    @IBAction func changeMessageRate(_ sender: Any) {
        updateSettingData()
    }
    
    @IBAction func changeCompassAngle(_ sender: Any) {
        updateSettingData()
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        print("should end editing!")
        beaconUuidValidate()
        return true
    }
    
    private func updateSettingData() {
        let texts:[String:String] = [
            "ipAdress": ipAdressTextField.text ?? "",
            "portNumber": portNumberTextField.text ?? "",
            "uuid": uuidTextField.text ?? "",
            "beaconUUID1": beaconUUIDTextFields[0].text ?? "",
            "beaconUUID2": beaconUUIDTextFields[1].text ?? "",
            "beaconUUID3": beaconUUIDTextFields[2].text ?? "",
            "beaconUUID4": beaconUUIDTextFields[3].text ?? "",
            "beaconUUID5": beaconUUIDTextFields[4].text ?? ""
        ]
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
        if ((beaconUUIDTextFields[0].text?.description ?? "").count != 8) {
            beaconUUIDTextFields[0].becomeFirstResponder()
        } else if ((beaconUUIDTextFields[1].text?.description ?? "").count  != 4){
            beaconUUIDTextFields[1].becomeFirstResponder()
        } else if ((beaconUUIDTextFields[2].text?.description ?? "").count  != 4){
            beaconUUIDTextFields[2].becomeFirstResponder()
        } else if ((beaconUUIDTextFields[3].text?.description ?? "").count  != 4){
            beaconUUIDTextFields[3].becomeFirstResponder()
        } else if ((beaconUUIDTextFields[4].text?.description ?? "").count  != 12){
            beaconUUIDTextFields[4].becomeFirstResponder()
        } else {
            updateSettingData()
            self.view.endEditing(true)
        }
    }
}

extension CommandDataSettingViewController: CommandDataSettingPresenterDelegate {}

extension CommandDataSettingViewController: UITextFieldDelegate {
    private func setTextFieldSetting(texField:UITextField, text:String) {
        texField.text = String(text)
        texField.delegate = self
    }
}

extension CommandDataSettingViewController: ContentScrollable{
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
