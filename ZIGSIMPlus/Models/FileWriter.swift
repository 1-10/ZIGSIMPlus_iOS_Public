//
//  FileWriter.swift
//  ZIGSIMPlus
//
//  Created by Takayosi Amagi on 2019/07/09.
//  Copyright © 2019 1→10, Inc. All rights reserved.
//

import Foundation

class FileWriter {
    static let shared = FileWriter()
    private init() {}

    var output: OutputStream?

    func open() {
        let dirpath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let datetime = Utils.getTimestamp()
        let format = AppSettingModel.shared.transportFormat == .OSC ? "osc" : "json"
        let filepath = "\(dirpath)/\(datetime).\(format).log"

        if let stream = OutputStream(toFileAtPath: filepath, append: true) {
            stream.open()
            output = stream
        } else {
            print("File I/O Error.")
        }
    }

    func write(_ text: String) {
        guard let data = text.data(using: .utf8) else { return }

        let bytesWritten = data.withUnsafeBytes {
            output?.write($0, maxLength: data.count)
        }

        if bytesWritten != data.count {
            print("Write failed")
        }
    }

    func close() {
        output?.close()
        output = nil
    }
}
