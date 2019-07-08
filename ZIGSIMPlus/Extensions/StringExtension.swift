//
//  StringExtension.swift
//  ZIGSIMPlus
//
//  Created by Nozomu Kuwae on 2019/05/23.
//  Copyright © 2019 1→10, Inc. All rights reserved.
//

import Foundation

extension String {
    /// Appends the given string to this string, with adding line break between them. If this string is empty or ends with line break, line break will not be not added.
    mutating func appendLines(_ other: String) {
        self = ((self.isEmpty || self.last == "\n") ? (self + other) : (self + "\n" + other))
    }
}
