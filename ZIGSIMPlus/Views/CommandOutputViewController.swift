//
//  CommandOutputViewController.swift
//  ZIGSIMPlus
//
//  Created by Nozomu Kuwae on 5/10/19.
//  Copyright © 2019 Nozomu Kuwae. All rights reserved.
//

import UIKit
import MediaPlayer

class CommandOutputViewController: UIViewController {
    @IBOutlet weak var textField: UITextView!
    
    var presenter: CommandOutputPresenterProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        // Dummy volume view to disable default system volume hooks
        let volumeView = MPVolumeView(frame: CGRect(x: -100, y: -100, width: 0, height: 0))
        view.addSubview(volumeView)
        
        presenter.startCommands()
    }

    override func viewDidDisappear(_ animated: Bool) {
        presenter.stopCommands()
    }

    // MARK: - Touch Events

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        TouchService.shared.addTouches(touches)
    }   

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        TouchService.shared.updateTouches(touches)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        TouchService.shared.removeTouches(touches)
    }

    override func touchesCancelled(_ touches: Set<UITouch>?, with event: UIEvent?) {
        TouchService.shared.removeAllTouches()
    }
}

extension CommandOutputViewController: CommandOutputPresenterDelegate {
    func updateOutput(with output: String) {
        textField.text = output
    }
}
