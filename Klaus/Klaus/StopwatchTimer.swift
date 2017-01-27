//
//  StopwatchTimer.swift
//  SimonSays
//
//  Created by Verena Schlott on 14.01.17.
//  Copyright (c) 2017 Verena Schlott. All rights reserved.
//

import Foundation

class StopwatchTimer:NSObject {
    
    var duration = 0
    var timer = Timer()
    
    func startTimer() {
        let aSelector: Selector = #selector(StopwatchTimer.updateTime)
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: aSelector, userInfo: nil, repeats: true)
    }
    
    func updateTime() {
        duration += 1
    }
    
    func stopTimer() {
        timer.invalidate()
    }
    
    func resetTimer() {
        timer.invalidate()
        duration = 0
    }
}
