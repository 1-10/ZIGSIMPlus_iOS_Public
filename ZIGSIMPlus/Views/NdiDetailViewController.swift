//
//  NdiDetailViewController.swift
//  ZIGSIMPlus
//
//  Created by YoneyamaShunpei on 2019/06/06.
//  Copyright © 2019 Nozomu Kuwae. All rights reserved.
//

import Foundation
import UIKit

public class NdiDetailViewController : UIViewController {
    
    @IBOutlet weak var segmentLabel: UILabel!
    @IBOutlet var segments: [UISegmentedControl]!
    var presenter: NdiDetailPresenterProtocol!
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        presenter = NdiDetailPresenter()
        let userDefaultSegments = presenter.getUserDefault()
        for segment in segments {
            if segment.tag == 0 {
                segment.selectedSegmentIndex = Int(userDefaultSegments[.NDI_TYPE] ?? 0)
            } else if segment.tag == 1 {
                segment.selectedSegmentIndex = Int(userDefaultSegments[.NDI_CAMERA_TYPE] ?? 0)
            } else if segment.tag == 2 {
                segment.selectedSegmentIndex = Int(userDefaultSegments[.DEPTH_TYPE] ?? 0)
            }
        }
    }
    
    @IBAction func segmentAction(_ sender: UISegmentedControl) {
        if sender.tag == 0 { // CAMERA or DEPTH
            presenter.updateNdiTypeUserDefault(selectIndex: sender.selectedSegmentIndex)
        } else if sender.tag == 1 { // OUTCAMERA or INCAMERA
            presenter.updateNdiCameraTypeUserDefault(selectIndex: sender.selectedSegmentIndex)
        } else if sender.tag == 2 { // DEPTH or DISPARITY
            presenter.updateDepthTypeUserDefault(selectIndex: sender.selectedSegmentIndex)
        }
    }
}
