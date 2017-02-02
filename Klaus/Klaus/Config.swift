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
    
    static var axeBasePointsPerSecond = 20;
    static var coffeeBasePointsPerSecond = 25;
    static var seitenschneidBasePointsPerSecond = 35;
    static var alarmBasePointsPerSecond = 15;
    
    static var scoreToLevelUpBase = 1000;
    
    static var stealBonus = 1000.0;
    static var stealPenalty = 1000.0;
    
    static var possibleColors = [UIColor(red:0.78, green:0.00, blue:0.49, alpha:1.0),
                                 UIColor(red:0.08, green:0.90, blue:0.80, alpha:1.0),
                                 UIColor(red:1.00, green:0.96, blue:0.03, alpha:1.0),
                                 UIColor(red:0.03, green:1.00, blue:0.09, alpha:1.0)]
    
}
