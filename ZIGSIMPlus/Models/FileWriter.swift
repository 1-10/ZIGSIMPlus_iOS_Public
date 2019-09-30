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
        let datetime = Utils.getTimestamp().replacingOccurrences(of: ":", with: ".")
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

        var bytesWritten: Int?
        data.withUnsafeBytes {
            bytesWritten = $0.count
            let baffer = $0.baseAddress!.assumingMemoryBound(to: UInt8.self)
            output?.write(baffer, maxLength: $0.count)
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
