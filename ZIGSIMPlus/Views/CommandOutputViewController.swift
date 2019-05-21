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

    // MARK: - Touch Events

    private func touchesWithPoints(_ touches: Set<UITouch>) -> [TouchData] {
        return touches.map {
            let pos = $0.location(in: view!)
            return TouchData(touch: $0, point: pos)
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        TouchDataStore.shared.addTouches(touchesWithPoints(touches))
    }   

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        // TBD
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        TouchDataStore.shared.removeTouches(touchesWithPoints(touches))
    }

    override func touchesCancelled(_ touches: Set<UITouch>?, with event: UIEvent?) {
        TouchDataStore.shared.removeAllTouches()
    }
}

extension CommandOutputViewController: CommandOutputPresenterDelegate {
    func updateOutput(with output: String) {
        textField.text = output
    }
}
