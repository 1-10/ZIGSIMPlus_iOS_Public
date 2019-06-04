//
//  NfcMonitoringCommand.swift
//  ZIGSIMPlus
//
//  Created by Nozomu Kuwae on 2019/05/30.
//  Copyright © 2019 Nozomu Kuwae. All rights reserved.
//

import Foundation
import CoreNFC

public final class NfcMonitoringCommand: AutoUpdatedCommand {
    public func isAvailable() -> Bool {
        return NfcDataStore.shared.isAvailable()
    }
    
    public func start(completion: ((String?) -> Void)?) {
        NfcDataStore.shared.callback = completion
        NfcDataStore.shared.start()
    }
    
    public func stop(completion: ((String?) -> Void)?) {
        NfcDataStore.shared.stop()
    }
}
