//
//  TermsOfUseViewController.swift
//  ZIGSIMPlus
//
//  Created by YoneyamaShunpei on 2019/06/27.
//  Copyright © 2019 1→10, Inc. All rights reserved.
//

import Foundation
import MarkdownKit
import UIKit

public class TermsOfUseViewController : UIViewController {
    @IBOutlet weak var text: UITextView!
    override public func viewDidLoad() {
        super.viewDidLoad()
        let filePath = Bundle.main.path(forResource: "TermsOfUse", ofType:"plist" )
        let plist = NSDictionary(contentsOfFile: filePath!)
        let termsOfuse:String? = plist?["TermsOfUse"] as? String
        let markdownParser = MarkdownParser(font: UIFont.systemFont(ofSize: 10))
        markdownParser.bold.font = UIFont.systemFont(ofSize: 24)
        text.attributedText = markdownParser.parse(termsOfuse ?? "")
        text.textColor = Theme.main
    }
}
