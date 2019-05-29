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
        
        let userDefaultTexts = presenter.getUserDefaultTexts()
        setTextFieldSetting(texField: ipAdressTextField, text: userDefaultTexts["ipAdress"]?.description ?? "")
        setTextFieldSetting(texField: portNumberTextField, text: userDefaultTexts["portNumber"]?.description ?? "")
        setTextFieldSetting(texField: uuidTextField, text: userDefaultTexts["uuid"]?.description ?? "")
        setTextFieldSetting(texField: beaconUUID1TextField, text: userDefaultTexts["beaconUUID1"]?.description ?? "")
        setTextFieldSetting(texField: beaconUUID2TextField, text: userDefaultTexts["beaconUUID2"]?.description ?? "")
        setTextFieldSetting(texField: beaconUUID3TextField, text: userDefaultTexts["beaconUUID3"]?.description ?? "")
        setTextFieldSetting(texField: beaconUUID4TextField, text: userDefaultTexts["beaconUUID4"]?.description ?? "")
        setTextFieldSetting(texField: beaconUUID5TextField, text: userDefaultTexts["beaconUUID5"]?.description ?? "")
        
        let userDefaultSegments = presenter.getUserDefaultSegments()
        dataDestinationSeg.selectedSegmentIndex = userDefaultSegments["userDataDestination"] ?? 0
        protocoloSeg.selectedSegmentIndex = userDefaultSegments["userProtocol"] ?? 0
        messageFormatSeg.selectedSegmentIndex = userDefaultSegments["userMessageFormat"] ?? 0
        messageRateSeg.selectedSegmentIndex = userDefaultSegments["userMessageRatePerSecond"] ?? 0
        compassAngleSeg.selectedSegmentIndex = userDefaultSegments["userCompassAngle"] ?? 0
        
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureObserver()
    }
    
    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeObserver()
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
    
    private func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        print("should end editing!")
        beaconUuidValidate()
        return true
    }
    
    private func setTextFieldSetting(texField:UITextField, text:String) {
        texField.text = String(text)
        texField.delegate = self
    }
    
    private func updateSettingData() {
        let texts:[String:String] = [
            "ipAdress": ipAdressTextField.text ?? "",
            "portNumber": portNumberTextField.text ?? "",
            "uuid": uuidTextField.text ?? "",
            "beaconUUID1": beaconUUID1TextField.text ?? "",
            "beaconUUID2": beaconUUID2TextField.text ?? "",
            "beaconUUID3": beaconUUID3TextField.text ?? "",
            "beaconUUID4": beaconUUID4TextField.text ?? "",
            "beaconUUID5": beaconUUID5TextField.text ?? ""
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
        if ((beaconUUID1TextField.text?.description ?? "").count != 8) {
            beaconUUID1TextField.becomeFirstResponder()
        } else if ((beaconUUID2TextField.text?.description ?? "").count  != 4){
            beaconUUID2TextField.becomeFirstResponder()
        } else if ((beaconUUID3TextField.text?.description ?? "").count  != 4){
            beaconUUID3TextField.becomeFirstResponder()
        } else if ((beaconUUID4TextField.text?.description ?? "").count  != 4){
            beaconUUID4TextField.becomeFirstResponder()
        } else if ((beaconUUID5TextField.text?.description ?? "").count  != 12){
            beaconUUID5TextField.becomeFirstResponder()
        } else {
            updateSettingData()
            self.view.endEditing(true)
        }
    }
}

extension CommandDataSettingViewController: CommandDataSettingPresenterDelegate {}

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
