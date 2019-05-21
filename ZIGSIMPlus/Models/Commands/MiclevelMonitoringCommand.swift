//
//  MiclevelMonitoringCommand.swift
//  ZIGSIMPlus
//
//  Created by YoneyamaShunpei on 2019/05/21.
//  Copyright © 2019 Nozomu Kuwae. All rights reserved.
//

import Foundation

public final class MiclevelMonitoringCommand: AutoUpdatedCommand {
    var audioLevel:AudioLevel!
    var timer:Timer!
    
    public func start(completion: ((String?) -> Void)?) {
        self.audioLevel = AudioLevel()
        self.audioLevel.start(fps: 1)
        
        self.timer = Timer.scheduledTimer(timeInterval: 0.001,
                             target: self,
                             selector: #selector(MiclevelMonitoringCommand.update),
                             userInfo: completion,
                             repeats: true)
    }
    
    public func stop(completion: ((String?) -> Void)?) {
        self.audioLevel.stop()
        self.timer.invalidate()
        completion?(nil)
    }
    
    @objc public func update(_ timer: Timer){
        var level = self.audioLevel.update()
        let completion = timer.userInfo as! (String?) -> Void
        completion("""
                miclevel:max:\(level[0])
                miclevel:average\(level[1])
            """)
    }
}
