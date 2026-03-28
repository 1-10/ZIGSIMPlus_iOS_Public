//
//  OSCExtension.swift
//  ZIGSIMPlus
//
//  Created by Takayosi Amagi on 2019/07/09.
//  Copyright © 2019 1-10, Inc. All rights reserved.
//

import Foundation
import OSCKit

extension OSCBundle {
    func getString() -> String {
        var output = ""

        for element in elements {
            if case .message(let message) = element {
                output += message.getString() + "\n"
            }
        }

        return output
    }
}

extension OSCMessage {
    func getString() -> String {
        var output = "\(addressPattern)"

        for value in values {
            if let int = value as? Int32 {
                output += " \(int)"
            } else if let float = value as? Float32 {
                output += " \(float)"
            } else if let double = value as? Double {
                output += " \(double)"
            } else if let string = value as? String {
                output += " \(string)"
            } else if let bool = value as? Bool {
                output += " \(bool)"
            }
        }

        return output
    }
}
