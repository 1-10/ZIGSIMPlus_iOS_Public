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

public class TermsOfUseViewController: UIViewController {
    @IBOutlet var text: UITextView!
    public override func viewDidLoad() {
        super.viewDidLoad()
        guard let filePath = Bundle.main.path(forResource: "TermsOfUse", ofType: "plist") else {
            NSLog("TermsOfUse.plist was not found in the main bundle.")
            DispatchQueue.main.async { [weak self] in
                if let navigationController = self?.navigationController {
                    navigationController.popViewController(animated: true)
                } else {
                    self?.dismiss(animated: true)
                }
            }
            return
        }
        let plist = NSDictionary(contentsOfFile: filePath)
        let termsOfuse: String? = plist?["TermsOfUse"] as? String
        let markdownParser = MarkdownParser(font: UIFont.systemFont(ofSize: 10))
        markdownParser.bold.font = UIFont.systemFont(ofSize: 24)
        text.attributedText = markdownParser.parse(termsOfuse ?? "")
        text.textColor = Theme.main
    }
}
