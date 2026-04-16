//
//  FileWriter.swift
//  ZIGSIMPlus
//
//  Created by Takayosi Amagi on 2019/07/09.
//  Copyright © 2019 1→10, Inc. All rights reserved.
//

import Foundation
import os.log

class FileWriter {
    static let shared = FileWriter()
    private static let log = OSLog(
        subsystem: Bundle.main.bundleIdentifier ?? "com.zigsim",
        category: "FileWriter"
    )

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
            os_log(
                "File I/O error opening log file: %{public}@",
                log: Self.log,
                type: .error,
                filepath
            )
        }
    }

    func write(_ text: String) {
        guard let data = text.data(using: .utf8) else { return }

        var bytesWritten: Int?
        data.withUnsafeBytes {
            bytesWritten = $0.count
            let buffer = $0.baseAddress!.assumingMemoryBound(to: UInt8.self)
            output?.write(buffer, maxLength: $0.count)
        }

        if bytesWritten != data.count {
            os_log(
                "File write failed. Expected %{public}d bytes, wrote %{public}d bytes.",
                log: Self.log,
                type: .error,
                data.count,
                bytesWritten ?? 0
            )
        }
    }

    func close() {
        output?.close()
        output = nil
    }
}
