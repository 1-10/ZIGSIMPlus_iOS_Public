//
//  FileAdapter.swift
//  ZIGSIMPlus
//
//  Created by Takayosi Amagi on 2019/07/09.
//  Copyright © 2019 1→10, Inc. All rights reserved.
//

import Foundation

class FileAdapter {
    static let shared = FileAdapter()
    private init() {}

    var fileHandle: FileHandle?

    func open() {
        let dirpath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let datetime = Utils.getTimestamp()
        let filepath = "\(dirpath)/\(datetime).json"
        print("open: \(filepath)")

        fileHandle = FileHandle(forWritingAtPath: filepath)

        var result = FileManager.default.fileExists(atPath: filepath)
        if !result {
            result = FileManager.default.createFile(atPath: filepath, contents: "".data(using: .utf8), attributes: nil)
        }
        if !result {
            print("File I/O Error.")
        }
    }

    func write(_ str: String) {
        let data = str.data(using: .utf8)!
        fileHandle?.write(data)
        print("wrote: \(str)")
    }

    func close() {
        fileHandle?.closeFile()
        fileHandle = nil
        print("closed")
    }
}
