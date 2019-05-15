//
//  CommandOutputViewController.swift
//  ZIGSIMPlus
//
//  Created by Nozomu Kuwae on 5/10/19.
//  Copyright © 2019 Nozomu Kuwae. All rights reserved.
//

import UIKit

class CommandOutputViewController: UIViewController {
    @IBOutlet weak var textField: UITextView!
    var presenter: CommandOutputPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        presenter.startCommands()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        presenter.stopCommands()
    }
}

extension CommandOutputViewController: CommandOutputPresenterDelegate {
    func updateOutput(with output: String) {
        textField.text = output
    }
}
