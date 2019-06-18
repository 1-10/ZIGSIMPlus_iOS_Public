//
//  TermsOfUseView.swift
//  ZIGSIMPlus
//
//  Created by YoneyamaShunpei on 2019/06/18.
//  Copyright © 2019 Nozomu Kuwae. All rights reserved.
//

import Foundation
import UIKit

public class TermsOfUseView: UIViewController {
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        let titleImageView = UIImageView(frame: CGRect(x: 100, y: 10, width: 200, height: 40))
        titleImageView.contentMode = .scaleAspectFit
        let titleImage = UIImage(named: "Logo")
        titleImageView.image = titleImage
    }
}
