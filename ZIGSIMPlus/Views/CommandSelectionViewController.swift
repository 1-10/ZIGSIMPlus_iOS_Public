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
    var cells:[Command:StandardCell] = [:]

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
    
    func setImageSegmentsAvailable(){
        setAvailable(true, forCell: cells[Command.ndi])
        setAvailable(true, forCell: cells[Command.arkit])
        setAvailable(true, forCell: cells[Command.imageDetection])
    }
    
    func setImageSegmentsUnavailable(_ selectedCommandNo: Int){
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
    
    private func adjustUnlockPremiumFeatureModalLabel() {
        unlockPremiumFeatureModalLabel.layer.cornerRadius = 10
        unlockPremiumFeatureModalLabel.layer.borderWidth = 1.0
        unlockPremiumFeatureModalLabel.layer.masksToBounds = true
        unlockPremiumFeatureModalLabel.layer.borderColor = Theme.gray.cgColor
        
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
        upperLayer.backgroundColor = Theme.darkgray.cgColor
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

        let commandToSelect = self.presenter.getCommandToSelect(forRow: indexPath.row)
        let cell = tableView.dequeueReusableCell(withIdentifier: "StandardCell", for: indexPath) as! StandardCell
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        tableView.separatorStyle = .none
        tableView.backgroundColor = Theme.dark
        
        cell.commandLabel.text = commandToSelect.labelString
        cell.commandLabel.tag = indexPath.row
        cell.commandOnOff.tag = indexPath.row
        cell.viewController = self
        cell.commandSelectionPresenter = self.presenter
        
        cells[Command.allCases[indexPath.row]] = cell
        cell.commandOnOff.isOn = AppSettingModel.shared.isActiveByCommand[Command.allCases[indexPath.row]] ?? false
        
        let mediator = CommandAndServiceMediator()
        if mediator.isAvailable(Command.allCases[indexPath.row]){
            setAvailable(true, forCell:cell)
        } else {
            setAvailable(false, forCell:cell)
        }

        cell.initCell()
        
        return cell
    }
    
    func setAvailable(_ isAvailable: Bool, forCell cell: StandardCell?) {
        cell?.commandOnOff.isEnabled = isAvailable
        cell?.detailButton.isEnabled = isAvailable
        if isAvailable {
            cell?.commandLabel.textColor = Theme.main
            cell?.detailButton.tintColor = Theme.main
            setDetailImageView(true, forCell: cell)
        } else {
            cell?.commandLabel.textColor = Theme.dark
            cell?.detailButton.tintColor = Theme.dark
            setDetailImageView(false, forCell: cell)
        }
    }
    
    func setDetailImageView(_ isAvailable: Bool,forCell cell: StandardCell? ) {
        let image: UIImage?
        cell?.detailButton.isHidden = true
        cell?.detailImageView.isHidden = true
        if  cell?.commandLabel.text == Command.ndi.rawValue ||
            cell?.commandLabel.text == Command.arkit.rawValue ||
            cell?.commandLabel.text == Command.imageDetection.rawValue ||
            cell?.commandLabel.text == Command.compass.rawValue ||
            cell?.commandLabel.text == Command.beacon.rawValue {
            cell?.detailButton.isHidden = false
            cell?.detailImageView.isHidden = false
            if isAvailable {
                image = UIImage(named: "ActiveDetailButton")
            } else {
                image = UIImage(named: "UnactiveDetailButton")
            }
            cell?.detailImageView.image = image
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
