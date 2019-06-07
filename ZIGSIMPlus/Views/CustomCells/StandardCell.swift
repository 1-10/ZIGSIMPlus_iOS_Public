//
//  StandardCell.swift
//  ZIGSIMPlus
//
//  Created by YoneyamaShunpei on 2019/06/06.
//  Copyright © 2019 Nozomu Kuwae. All rights reserved.
//

import Foundation
import UIKit

public class StandardCell: UITableViewCell {
   
    @IBOutlet weak var commandOnOff: UISwitch!
    @IBOutlet weak var commandLabel: UILabel!
    @IBOutlet weak var settingButton: UIButton!
    @IBOutlet weak var modalButton: UIButton!
    
    var commandSelectionPresenter: CommandSelectionPresenterProtocol!
    var tableview: UITableView!
    var viewController: UIViewController!
    var backButtonLabel: UIButton!
    let commands:[Int: Command] = [
        0: Command.acceleration,
        1: Command.gravity,
        2: Command.gyro,
        3: Command.quaternion,
        4: Command.compass,
        5: Command.pressure,
        6: Command.gps,
        7: Command.touch,
        8: Command.beacon,
        9: Command.proximity,
        10: Command.micLevel,
        11: Command.remoteControl,
        12: Command.ndi,
        13: Command.arkit,
        14: Command.faceTracking,
        15: Command.battery,
        16: Command.applePencil
    ]
    
    @IBAction func commandOnOffAction(_ sender: UISwitch) {
        print("ok")
        print("tag: \(sender.tag)")
        print("command:\(commands[sender.tag]!.rawValue)")
        commandSelectionPresenter.didSelectRow(atLabel: commands[sender.tag]!.rawValue)
    }
    
    @IBAction func settingButtonAction(_ sender: UIButton) {
        print("ok1")
        tableview.isHidden = true
        backButtonLabel.isHidden = false
        /*
        let children = viewController.children[0] as! CommandDetaileViewController
        children.segment.isHidden = false
        children.segmentLabel.isHidden = false
         */
        //        let parentVC = self.parent as! CommandSelectionViewController
        //        parentVC.tableView.isHidden = false
        //viewController.performSegue(withIdentifier: "detaileView", sender: "ok")
    }
    
    @IBAction func modalButtonAction(_ sender: UIButton) {
        print("ok2")
    }
    
    
}
