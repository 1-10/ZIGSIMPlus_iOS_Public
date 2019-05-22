//
//  CommandDataOutputViewController.swift
//  ZIGSIMPlus
//
//  Created by Nozomu Kuwae on 5/10/19.
//  Copyright © 2019 Nozomu Kuwae. All rights reserved.
//

import UIKit

class CommandDataOutputViewController: UIViewController {
    @IBOutlet weak var textField: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    var presenter: CommandDataOutputPresenterProtocol!

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

extension CommandDataOutputViewController: CommandDataOutputPresenterDelegate {
    func updateOutput(with output: String) {
        textField.text = output
    }

    func updateImagePreview(with image: UIImage) {
        imageView.image = image
    }
}
