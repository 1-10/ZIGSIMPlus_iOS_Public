//
//  CommandSelectionViewController.swift
//  ZIGSIMPlus
//
//  Created by Nozomu Kuwae on 5/10/19.
//  Copyright © 2019 1→10, Inc. All rights reserved.
//

import UIKit
import SVProgressHUD
import MarkdownKit

typealias CommandToSelect = (labelString: String, isAvailable: Bool)

enum alertModalType{
    case premium
    case detailSetting
}

final class CommandSelectionViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lockPremiumFeatureLabel: UILabel!
    @IBOutlet weak var unlockPremiumFeatureButton: UIButton!
    
    var presenter: CommandSelectionPresenterProtocol!
    var cells:[Command:StandardCell] = [:]
    var unAvailablePremiumCommands:[Command] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.loadCommandOnOffFromUserDefaults()
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
    
    func setNdiArkitImageDetectionButtonAvailable() {
        setAvailable(true, forCell: cells[Command.ndi])
        setAvailable(true, forCell: cells[Command.arkit])
        setAvailable(true, forCell: cells[Command.imageDetection])
    }
    
    
    func setSelectedButtonAvailable(_ selectedCommandNo: Int){
        let selectedCommand = Command.allCases[selectedCommandNo]
        switch selectedCommand {
        case .ndi:
            setAvailable(false, forCell: cells[Command.arkit])
            setAvailable(false, forCell: cells[Command.imageDetection])
        case .arkit:
            setAvailable(false, forCell: cells[Command.imageDetection])
            setAvailable(false, forCell: cells[Command.ndi])
        case .imageDetection:
            setAvailable(false, forCell: cells[Command.ndi])
            setAvailable(false, forCell: cells[Command.arkit])
        default:
            return
        }
    }
    
    @IBAction func actionButton(_ sender: UIButton) {
        let message = getAlertMessageForPurchase()
        showAlertWithMarkdownMessage(title: premiumTextTitle, message: message, alertType: .premium)
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

        showAlertWithMarkdownMessage(title:title, message: msg, alertType: .detailSetting)
    }
    
    func showAlertWithMarkdownMessage(title: String, message: String, alertType: alertModalType) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let attributedText = convertMessageFromStringToAttributedText(message)
        alert.setValue(attributedText, forKey: "attributedMessage")
        
        switch alertType {
        case .premium:
            alert.addAction(UIAlertAction(title: "Back", style: .default))
            alert.addAction(UIAlertAction(title: "Purchase", style: .default, handler: { action in
                self.tableView.isUserInteractionEnabled = false
                SVProgressHUD.show()
                self.presenter.purchase()
            }))
        case .detailSetting:
            alert.addAction(UIAlertAction(title: "See Docs", style: .default, handler: { action in
                UIApplication.shared.open(URL(string: "https://zig-project.com/")!, options: [:])
            }))
            alert.addAction(UIAlertAction(title: "OK", style: .default))
        }
        
        present(alert, animated: true, completion: {
            alert.view.superview?.isUserInteractionEnabled = true
        })
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
    }
    
    private func unlockPremiumFeature() {
        // "tableView.reloadData()" is used to update availability of command.
        // e.g. If user come back to this View,after pushing the Restore Purchase Button in Setting View.
        tableView.reloadData()
        setPremiumFeatureIsHidden(true)
    }
    
    private func setPremiumFeatureIsHidden(_ isHidden: Bool) {
        lockPremiumFeatureLabel.isHidden = isHidden
        unlockPremiumFeatureButton.isHidden = isHidden
    }
    
    private func adjustLockPremiumFeatureLabel() {
        lockPremiumFeatureLabel.frame = CGRect(x:0,y:0,width: UIScreen.main.bounds.size.width, height: 44 * 5)
        lockPremiumFeatureLabel.backgroundColor = Theme.overlay
    }
    
    private func adjustUnlockPremiumFeatureButton() {
        let billingImage = UIImage(named: "key")
        unlockPremiumFeatureButton.tintColor = Theme.white.withAlphaComponent(0.7)
        unlockPremiumFeatureButton.setImage(billingImage, for: .normal)
        unlockPremiumFeatureButton.frame = CGRect(x: (lockPremiumFeatureLabel.frame.size.width - unlockPremiumFeatureButton.frame.size.width ) / 2,
                                        y: (lockPremiumFeatureLabel.frame.size.height - unlockPremiumFeatureButton.frame.size.height ) / 2,
                                        width: unlockPremiumFeatureButton.frame.size.width ,
                                        height: unlockPremiumFeatureButton.frame.size.height)
    }
    
    private func getAlertMessageForPurchase() -> String {
        var message = premiumTextBody
        if  unavailablePremiumFunctionCount > 0 {
            message += (unavailablePremiumFunctionCount >= 2
                ? "\n\nThe following functions don't work on this device:"
                : "\n\nThe following function doesn't work on this device:")

            for unAvailablePremiumCommand in unAvailablePremiumCommands {
                message += "\n- " + unAvailablePremiumCommand.rawValue
            }
            if !unAvailablePremiumCommands.contains(Command.ndi) {
                if !VideoCaptureService.shared.isDepthRearCameraAvailable() {
                    message += "\n- NDI Depth function"
                }
                if VideoCaptureService.shared.isDepthRearCameraAvailable() && !VideoCaptureService.shared.isDepthFrontCameraAvailable(){
                    message += "\n- NDI Depth function on front camera"
                }
            }
        }
        
        return message
    }
    
    private func convertMessageFromStringToAttributedText(_ msg: String) -> NSMutableAttributedString {
        let markdownParser = MarkdownParser()
        return NSMutableAttributedString(attributedString: markdownParser.parse(msg))
    }
    
    private var unavailablePremiumFunctionCount: Int {
        var count = unAvailablePremiumCommands.count
        if !VideoCaptureService.shared.isDepthRearCameraAvailable() {
            count += 1
        } else {
            if !VideoCaptureService.shared.isDepthFrontCameraAvailable() {
                count += 1
            }
        }
        
        return count
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

        let commandToSelect = self.presenter.getCommandToSelect(forRow: indexPath.row)
        let cell = tableView.dequeueReusableCell(withIdentifier: "StandardCell", for: indexPath) as! StandardCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        tableView.separatorStyle = .none
        tableView.backgroundColor = Theme.black
        cell.commandLabel.text = commandToSelect.labelString
        cell.commandLabel.tag = indexPath.row
        cell.commandOnOffButton.tag = indexPath.row
        cell.viewController = self
        cell.commandSelectionPresenter = self.presenter
        cells[Command.allCases[indexPath.row]] = cell
        
        if AppSettingModel.shared.isActiveByCommand[Command.allCases[indexPath.row]]! {
          cell.checkMarkLavel.text = checkMark
        } else {
          cell.checkMarkLavel.text = ""
        }

        if CommandAndServiceMediator.isAvailable(Command.allCases[indexPath.row]){
            setAvailable(true, forCell:cell)
        } else {
            setAvailable(false, forCell:cell)
            if Command.allCases[indexPath.row].isPremium && !presenter.isPremiumFeaturePurchased {
                unAvailablePremiumCommands.append(Command.allCases[indexPath.row])
                let orderedSet: NSOrderedSet = NSOrderedSet(array: unAvailablePremiumCommands)
                unAvailablePremiumCommands = orderedSet.array as! [Command]
            }
        }
        
        if !presenter.isPremiumFeaturePurchased && Command.allCases[indexPath.row].isPremium {
            setAvailable(false,forCell: cell)
        }

        cell.initCell()
        
        return cell
    }
    
    func setAvailable(_ isAvailable: Bool, forCell cell: StandardCell?) {
        cell?.commandOnOffButton.isEnabled = isAvailable
        if isAvailable {
            cell?.commandLabel.textColor = Theme.main
            cell?.detailButton.tintColor = Theme.main
            setDetailButton(isCommandAvailable: true, forCell: cell)
        } else {
            cell?.commandLabel.textColor = Theme.dark
            cell?.detailButton.tintColor = Theme.dark
            setDetailButton(isCommandAvailable: false, forCell: cell)
        }
    }
    
    func setDetailButton(isCommandAvailable: Bool, forCell cell: StandardCell?) {
        if hasDetailView(commandLabel: cell?.commandLabel.text) {
            cell?.detailButton.isHidden = false
            cell?.detailImageView.isHidden = false
            let image: UIImage?
            if isCommandAvailable {
                image = UIImage(named: "ActiveDetailButton")
            } else {
                image = UIImage(named: "UnactiveDetailButton")
            }
            cell?.detailImageView.image = image
        } else {
            cell?.detailButton.isHidden = true
            cell?.detailImageView.isHidden = true
        }
    }
    
    func hasDetailView(commandLabel: String?) -> Bool {
        if commandLabel == Command.ndi.rawValue ||
            commandLabel == Command.arkit.rawValue ||
            commandLabel == Command.imageDetection.rawValue ||
            commandLabel == Command.compass.rawValue ||
            commandLabel == Command.beacon.rawValue {
            return true
        }
        return false
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
