//
//  StopwatchTimer.swift
//  SimonSays
//
//  Created by Verena Schlott on 14.01.17.
//  Copyright (c) 2017 Verena Schlott. All rights reserved.
//

import Foundation

class StopwatchTimer:NSObject {
    
    var maxDuration: Int!
    var needGameUpdate: Bool!
    var duration = 0
    var timer = Timer()
    
    init(needGameUpdate: Bool, maxDuration: Int) {
        self.needGameUpdate = needGameUpdate
        self.maxDuration = maxDuration
    }
    
    func startTimer() {
        let aSelector: Selector = #selector(StopwatchTimer.updateTime)
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: aSelector, userInfo: nil, repeats: true)
    }
    
    func updateTime() {
        duration += 1
        if needGameUpdate! && duration >= maxDuration {
            NotificationCenter.default.post(name: NotificationCenterKeys.timerMaxDurationReached, object: nil, userInfo: nil)
        }
        NotificationCenter.default.post(name: NotificationCenterKeys.timerAfterOneSecond, object: nil, userInfo: nil)
    }
    
    func stopTimer() {
        timer.invalidate()
    }
    
    func resetTimer() {
        timer.invalidate()
        duration = 0
    }
}
