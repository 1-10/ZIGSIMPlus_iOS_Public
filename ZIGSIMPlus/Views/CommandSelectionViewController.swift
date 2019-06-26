//
//  CommandSelectionViewController.swift
//  ZIGSIMPlus
//
//  Created by Nozomu Kuwae on 5/10/19.
//  Copyright © 2019 Nozomu Kuwae. All rights reserved.
//

import UIKit
import SVProgressHUD
import MarkdownKit

typealias CommandToSelect = (labelString: String, isAvailable: Bool)

final class CommandSelectionViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lockPremiumFeatureLabel: UILabel!
    @IBOutlet weak var unlockPremiumFeatureButton: UIButton!
    @IBOutlet weak var unlockPremiumFeatureModalView: UIView!
    @IBOutlet weak var unlockPremiumFeatureModalLabel: UILabel!
    
    var presenter: CommandSelectionPresenterProtocol!
    var alert: UIAlertController = UIAlertController() // dummy

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib(nibName: "StandardCell", bundle: nil), forCellReuseIdentifier: "StandardCell")
        adjustNavigationDesign()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Check here to switch lock/unlock after restore
        if presenter.isPremiumFeaturePurchased {
            unlockPremiumFeature()
        } else {
            lockPremiumFeature()
        }
    }
    
    @IBAction func actionButton(_ sender: UIButton) {
        print("sender.tag: \(sender.tag)")
        if sender.tag == 1 { // "sender.tag == 1" is the unlock button
            unlockPremiumFeatureModalView.isHidden = false
            tableView.isUserInteractionEnabled = false
        } else if sender.tag == 2 { // "sender.tag == 2" is the back button of unlock modal
            unlockPremiumFeatureModalView.isHidden = true
            tableView.isUserInteractionEnabled = true
        } else if sender.tag == 3 { // "sender.tag == 3" is the purchase button of unlock modal
            unlockPremiumFeatureModalView.isHidden = true
            tableView.isUserInteractionEnabled = false
            SVProgressHUD.show()
            presenter.purchase()
        }
    }
    
    public func showDetail(commandNo: Int) {
        let command = Command.allCases[commandNo]

        // Get detail view controller
        switch command {
        case .compass, .ndi, .arkit, .beacon, .imageDetection:
            let vc = storyboard!.instantiateViewController(withIdentifier: "CommandDetailSettingsView") as! CommandDetailSettingsViewController
            vc.command = command

            // Move to detail view
            guard let navCtrl = navigationController else {
                fatalError("CommandSelectionView must be embedded in NavigationController")
            }
            navCtrl.pushViewController(vc, animated: true)

        default:
            return // Do nothing if detail view for the command is not found
        }
    }
    
    public func showModal(commandNo: Int) {
        let command = Command.allCases[commandNo]

        guard let (title: title, body: msg) = modalTexts[command] else {
            fatalError("Invalid command: \(command)")
        }

        alert = UIAlertController(title: title, message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "See Docs", style: .default, handler: { action in
            UIApplication.shared.open(URL(string: "https://zig-project.com/")!, options: [:])
        }))
        alert.addAction(UIAlertAction(title: "OK", style: .default))

        // Convert msg string to attributed text
        let markdownParser = MarkdownParser()
        let aText = NSMutableAttributedString(attributedString: markdownParser.parse(msg))

        alert.setValue(aText, forKey: "attributedMessage")

        present(alert, animated: true, completion: {
            self.alert.view.superview?.isUserInteractionEnabled = true
            self.alert.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.hideAlert)))
        })
    }

    @objc private func hideAlert() {
        alert.dismiss(animated: true, completion: nil)
    }
    
    private func adjustNavigationDesign() {
        Utils.setTitleImage(navigationController!.navigationBar)
        navigationController?.navigationBar.barTintColor = Theme.dark
        navigationController?.navigationBar.tintColor = Theme.main
    }

    private func lockPremiumFeature() {
        setPremiumFeatureIsHidden(false)
        adjustLockPremiumFeatureLabel()
        adjustUnlockPremiumFeatureButton()
        adjustUnlockPremiumFeatureModalLabel()
    }
    
    private func unlockPremiumFeature() {
        setPremiumFeatureIsHidden(true)
    }
    
    private func setPremiumFeatureIsHidden(_ isHidden: Bool) {
        lockPremiumFeatureLabel.isHidden = isHidden
        unlockPremiumFeatureButton.isHidden = isHidden
        unlockPremiumFeatureModalView.isHidden = isHidden
        unlockPremiumFeatureModalLabel.isHidden = isHidden
    }
    
    private func adjustLockPremiumFeatureLabel() {
        lockPremiumFeatureLabel.frame = CGRect(x:0,y:0,width: UIScreen.main.bounds.size.width, height: 44 * 5)
        lockPremiumFeatureLabel.backgroundColor = UIColor(displayP3Red: 0, green: 161/255, blue: 101/255, alpha: 0.46)
    }
    
    private func adjustUnlockPremiumFeatureButton() {
        let billingImage = UIImage(named: "key")
        unlockPremiumFeatureButton.tintColor = UIColor(displayP3Red: 255/255, green: 255/255, blue: 255/255, alpha: 0.7)
        unlockPremiumFeatureButton.setImage(billingImage, for: .normal)
        unlockPremiumFeatureButton.frame = CGRect(x: (lockPremiumFeatureLabel.frame.size.width - unlockPremiumFeatureButton.frame.size.width ) / 2,
                                        y: (lockPremiumFeatureLabel.frame.size.height - unlockPremiumFeatureButton.frame.size.height ) / 2,
                                        width: unlockPremiumFeatureButton.frame.size.width ,
                                        height: unlockPremiumFeatureButton.frame.size.height)
    }
    
    private func adjustUnlockPremiumFeatureModalLabel() {
        unlockPremiumFeatureModalLabel.layer.cornerRadius = 10
        unlockPremiumFeatureModalLabel.layer.borderWidth = 1.0
        unlockPremiumFeatureModalLabel.layer.masksToBounds = true
        unlockPremiumFeatureModalLabel.layer.borderColor = UIColor(displayP3Red: 103/255, green: 103/255, blue: 103/255, alpha: 1.0).cgColor
        
        adjustUnlockPremiumFeatureModalLine(x: 0,
                               y: unlockPremiumFeatureModalLabel.frame.size.height - 44,
                               width: unlockPremiumFeatureModalLabel.frame.size.width,
                               height: 1)
        adjustUnlockPremiumFeatureModalLine(x: unlockPremiumFeatureModalLabel.frame.size.width / 2,
                               y: unlockPremiumFeatureModalLabel.frame.size.height - 44,
                               width: 1,
                               height: unlockPremiumFeatureModalLabel.frame.size.height - 44)
        
        unlockPremiumFeatureModalView.isHidden = true
    }
    
    private func adjustUnlockPremiumFeatureModalLine(x:CGFloat, y:CGFloat, width:CGFloat, height:CGFloat) {
        let upperLayer = CALayer()
        upperLayer.frame = CGRect(
            x: x,
            y: y,
            width: width,
            height: height
        )
        upperLayer.backgroundColor = UIColor(displayP3Red: 63/255, green: 63/255, blue: 63/255, alpha: 1.0).cgColor
        unlockPremiumFeatureModalLabel.layer.addSublayer(upperLayer)
    }
}

extension CommandSelectionViewController: UITableViewDelegate {
    
    // Disallow selecting unavailable command
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if let cell = tableView.cellForRow(at: indexPath) {
            let ip = tableView.indexPath(for: cell)!
            let CommandToSelect = presenter.getCommandToSelect(forRow: ip.row)
            if !CommandToSelect.isAvailable {
                return nil
            }
        }
        return indexPath
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        lockPremiumFeatureLabel.frame = CGRect(x: 0, y: (-1) * scrollView.contentOffset.y, width: lockPremiumFeatureLabel.frame.size.width , height: lockPremiumFeatureLabel.frame.size.height)
        unlockPremiumFeatureButton.frame = CGRect(x: (lockPremiumFeatureLabel.frame.size.width - unlockPremiumFeatureButton.frame.size.width ) / 2,
                                        y: (lockPremiumFeatureLabel.frame.size.height - unlockPremiumFeatureButton.frame.size.height ) / 2 - scrollView.contentOffset.y,
                                        width: unlockPremiumFeatureButton.frame.size.width ,
                                        height: unlockPremiumFeatureButton.frame.size.height)
    }
}

extension CommandSelectionViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfCommandToSelect
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let CommandToSelect = self.presenter.getCommandToSelect(forRow: indexPath.row)
        let cell = tableView.dequeueReusableCell(withIdentifier: "StandardCell", for: indexPath) as! StandardCell
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        tableView.separatorStyle = .none
        tableView.backgroundColor = Theme.dark
        
        cell.commandLabel.text = CommandToSelect.labelString
        cell.commandLabel.tag = indexPath.row
        cell.commandOnOff.tag = indexPath.row
        cell.viewController = self
        cell.commandSelectionPresenter = self.presenter
        
        cell.detailButton.isHidden = false
        if CommandToSelect.labelString == Command.acceleration.rawValue ||
           CommandToSelect.labelString == Command.gravity.rawValue ||
           CommandToSelect.labelString == Command.gyro.rawValue ||
           CommandToSelect.labelString == Command.quaternion.rawValue ||
           CommandToSelect.labelString == Command.pressure.rawValue ||
           CommandToSelect.labelString == Command.gps.rawValue ||
           CommandToSelect.labelString == Command.touch.rawValue ||
           CommandToSelect.labelString == Command.proximity.rawValue ||
           CommandToSelect.labelString == Command.micLevel.rawValue ||
           CommandToSelect.labelString == Command.remoteControl.rawValue {
           cell.detailButton.isHidden = true
        }

        if AppSettingModel.shared.isActiveByCommand[Command.allCases[indexPath.row]] == true {
            cell.commandOnOff.isOn = true
        } else {
            cell.commandOnOff.isOn = false
        }
        
        let mediator = CommandAndServiceMediator()
        if mediator.isAvailable(Command.allCases[indexPath.row]){
            setAvailable(true, forCell:cell)
        } else {
            setAvailable(false, forCell:cell)
        }

        cell.initCell()
        
        return cell
    }
    
    func setAvailable(_ isAvailable: Bool, forCell cell: StandardCell) {
        cell.commandOnOff.isEnabled = isAvailable
        cell.detailButton.isEnabled = isAvailable
        if isAvailable {
            cell.commandLabel.textColor = UIColor(displayP3Red: 2/255, green: 141/255, blue: 90/255, alpha: 1.0)
            cell.detailButton.strokeColor = UIColor(displayP3Red: 2/255, green: 141/255, blue: 90/255, alpha: 1.0)
        } else {
            cell.commandLabel.textColor = UIColor(displayP3Red: 103/255, green: 103/255, blue: 103/255, alpha: 1.0)
            cell.detailButton.strokeColor = UIColor(displayP3Red: 103/255, green: 103/255, blue: 103/255, alpha: 1.0)
        }
    }
}

extension CommandSelectionViewController: CommandSelectionPresenterDelegate {
    func showPurchaseResult(isSuccessful: Bool, title: String?, message: String?) {
        SVProgressHUD.dismiss()
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Close", style: .default) { _ in
            if isSuccessful {
                self.unlockPremiumFeature()
            }
            self.tableView.isUserInteractionEnabled = true
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}
