//
//  CommandDataOutputViewController.swift
//  ZIGSIMPlus
//
//  Created by Nozomu Kuwae on 5/10/19.
//  Copyright © 2019 Nozomu Kuwae. All rights reserved.
//

import UIKit
import MediaPlayer

class CommandDataOutputViewController: UIViewController {
    @IBOutlet weak var textField: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var arkitView: UIView!

    var presenter: CommandDataOutputPresenterProtocol!

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
        TouchDataStore.shared.addTouches(touches)
    }   

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        TouchDataStore.shared.updateTouches(touches)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        TouchDataStore.shared.removeTouches(touches)
    }

    override func touchesCancelled(_ touches: Set<UITouch>?, with event: UIEvent?) {
        TouchDataStore.shared.removeAllTouches()
    }
}

extension CommandDataOutputViewController: CommandDataOutputPresenterDelegate {
    func updateOutput(with output: String) {
        textField.text = output
    }

    func updateImagePreview(with image: UIImage) {
        imageView.image = image
    }

    func setImageViewActive(_ active: Bool) {
        imageView.isHidden = !active
    }

    func setSceneViewActive(_ active: Bool) {
        arkitView.isHidden = !active
    }
}
