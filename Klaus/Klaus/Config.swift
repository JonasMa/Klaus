//
//  Config.swift
//  Klaus
//
//  Created by Alex Knittel on 25.01.17.
//  Copyright © 2017 Nimm Swag. All rights reserved.
//

import Foundation
import UIKit

struct Config {
    
    static var clearPlayerDataOnNextLaunch = false;
    
    // points per second w/ lvl 1
    static var axeBasePointsPerSecond = 20;
    static var coffeeBasePointsPerSecond = 25;
    static var seitenschneidBasePointsPerSecond = 35;
    static var alarmBasePointsPerSecond = 15;
    
    static var scoreToLevelUpBase = 1000;
    
    static var stealBonus = 1000.0;
    static var stealPenalty = 1000.0;
    
    static var possibleColors = [UIColor.red,
                                 UIColor.blue,
                                 UIColor.orange,
                                 UIColor.green,
                                 UIColor.yellow,
                                 UIColor.cyan]
    
}
