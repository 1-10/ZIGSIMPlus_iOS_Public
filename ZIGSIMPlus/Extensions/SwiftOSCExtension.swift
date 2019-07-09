//
//  SwiftOSCExtension.swift
//  ZIGSIMPlus
//
//  Created by Takayosi Amagi on 2019/07/09.
//  Copyright © 2019 1→10, Inc. All rights reserved.
//

import Foundation
import SwiftOSC

extension OSCBundle {
    func getString() -> String {
        var output = ""

        for element in elements {
            if let message = element as? OSCMessage {
                output += message.getString() + "\n"
            }
        }

        return output
    }
}

extension OSCMessage {
    func getString() -> String {
        var output = "\(address.string)"

        for argument in arguments {
            if let int = argument as? Int {
                output += " \(int)"
            }
            if let float = argument as? Float {
                output += " \(float)"
            }
            if let float = argument as? Double {
                output += " \(float)"
            }
            if let string = argument as? String {
                output += " \(string)"
            }
            if let bool = argument as? Bool {
                output += " \(bool)"
            }

            // Not used in ZIGSIM so far
            // if let blob = argument as? Blob {
            //    output += " Blob\(blob)"
            // }
            // if argument == nil {
            //     output += " <null>"
            // }
            // if argument is Impulse {
            //     output += " <impulse>"
            // }
            // if let timetag = argument as? Timetag {
            //     output += " Timetag<\(timetag)>"
            // }
        }

        return output
    }
}
