//
//  CommandSelectionViewController.swift
//  ZIGSIMPlus
//
//  Created by Nozomu Kuwae on 5/10/19.
//  Copyright © 2019 Nozomu Kuwae. All rights reserved.
//

import UIKit

typealias CommandToSelect = (labelString: String, isAvailable: Bool)

final class CommandSelectionViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var modalLabel: UILabel!
    @IBOutlet weak var modalButton: UIButton!
    @IBOutlet weak var lockPremiumFeatureLabel: UILabel!
    @IBOutlet weak var unlockPremiumFeatureButton: UIButton!
    @IBOutlet weak var unlockPremiumFeatureModalView: UIView!
    @IBOutlet weak var unlockPremiumFeatureModalLabel: UILabel!
    
    var presenter: CommandSelectionPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if !presenter.isPremiumFeaturePurchased {
            lockPremiumFeature()
        } else {
            setPremiumFeatureIsHidden(true)
        }
        
        isHiddenInformationModal(isHedden: true)
        
        self.tableView.register(UINib(nibName: "StandardCell", bundle: nil), forCellReuseIdentifier: "StandardCell")

        adjustNavigationDesign()
    }
    
    @IBAction func actionButton(_ sender: UIButton) {
        print("sender.tag: \(sender.tag)")
        if sender.tag == 0 { // "sender.tag == 0" is the back button of information modal
            isHiddenInformationModal(isHedden: true)
        } else if sender.tag == 1 { // "sender.tag == 1" is the unlock button
            unlockPremiumFeatureModalView.isHidden = false
            tableView.isUserInteractionEnabled = false
        } else if sender.tag == 2 { // "sender.tag == 2" is the back button of unlock modal
            unlockPremiumFeatureModalView.isHidden = true
            tableView.isUserInteractionEnabled = true
        } else if sender.tag == 3 { // "sender.tag == 3" is the purchase button of unlock modal
            
        }
    }
    
    public func showDetail(commandNo: Int) {
        let command = Command.allCases[commandNo]

        // Get detail view controller
        switch command {
        case .compass, .ndi, .arkit:
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
        isHiddenInformationModal(isHedden: false)
        modalLabel.numberOfLines = 10
        let command = Command.allCases[commandNo]
        modalLabel.text = modalTexts[command]
    }
    
    private func isHiddenInformationModal(isHedden:Bool) {
        modalLabel.isHidden = isHedden
        modalButton.isHidden = isHedden
    }
    
    private func adjustNavigationDesign() {
        let titleImage = UIImage(named: "Logo")
        let titleImageView = UIImageView(image: titleImage)
        titleImageView.contentMode = .scaleAspectFit
        navigationItem.titleView = titleImageView
        navigationController?.navigationBar.barTintColor = UIColor(displayP3Red: 33/255, green: 33/255, blue: 33/255, alpha: 1.0)
        navigationController?.navigationBar.tintColor = UIColor(displayP3Red: 0, green: 161/255, blue: 101/255, alpha: 1.0)
    }
    
    private func lockPremiumFeature() {
        setPremiumFeatureIsHidden(false)
        adjustLockPremiumFeatureLabel()
        adjustUnlockPremiumFeatureButton()
        adjustUnlockPremiumFeatureModalLabel()
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
        
        // Set cell's tap action style
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor(displayP3Red: 13/255, green: 12/255, blue: 12/255, alpha: 1.0)
        
        // Set cell's variable
        cell.commandLabel.text = CommandToSelect.labelString
        cell.commandLabel.tag = indexPath.row
        cell.commandOnOff.tag = indexPath.row
        cell.viewController = self
        cell.commandSelectionPresenter = self.presenter
        
        // Set cell's detail button to visible or invisible
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

        // Make an adjustment table view screen
        if AppSettingModel.shared.isActiveByCommand[Command.allCases[indexPath.row]] == true {
            cell.commandOnOff.isOn = true
        } else {
            cell.commandOnOff.isOn = false
        }
        
        // Set cell's UI design
        cell.initCell()
        
        return cell
    }
}

extension CommandSelectionViewController: CommandSelectionPresenterDelegate {
}
