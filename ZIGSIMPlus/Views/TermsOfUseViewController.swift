//
//  TermsOfUseViewController.swift
//  ZIGSIMPlus
//
//  Created by YoneyamaShunpei on 2019/06/27.
//  Copyright © 2019 Nozomu Kuwae. All rights reserved.
//

import Foundation
import MarkdownKit
import UIKit

public class TermsOfUseViewController : UIViewController {
    @IBOutlet weak var text: UITextView!
    override public func viewDidLoad() {
        super.viewDidLoad()
        let markdownParser = MarkdownParser(font: UIFont.systemFont(ofSize: 10))
        markdownParser.bold.font = UIFont.systemFont(ofSize: 24)
        text.attributedText = markdownParser.parse(termsOfUseText)
        text.textColor = Theme.main
    }
}
