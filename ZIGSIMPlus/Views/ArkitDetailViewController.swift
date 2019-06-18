//
//  ArkitDetailViewController.swift
//  ZIGSIMPlus
//
//  Created by Takayosi Amagi on 2019/06/17.
//  Copyright © 2019 Nozomu Kuwae. All rights reserved.
//

import Foundation
import UIKit

public class ArkitDetailViewController : UIViewController {

    var presenter: ArkitDetailPresenterProtocol!
    @IBOutlet weak var trackingModeSelector: UISegmentedControl!

    override public func viewDidLoad() {
        super.viewDidLoad()
        presenter = ArkitDetailPresenter()

        let ud = presenter.getUserDefault()
        trackingModeSelector.selectedSegmentIndex = Int(ud[.trackingMode] ?? 0)
    }

    @IBAction func segmentAction(_ sender: UISegmentedControl) {
        if sender.tag == 0 {
            presenter.updateArkitTrackingTypeUserDefault(selectIndex: sender.selectedSegmentIndex)
        }
    }
}
