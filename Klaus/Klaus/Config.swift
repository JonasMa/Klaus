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
    
    static let axeBasePointsPerSecond = 4;
    static let coffeeBasePointsPerSecond = 5;
    static let seitenschneidBasePointsPerSecond = 6;
    static let alarmBasePointsPerSecond = 7;
    
    static let scoreToLevelUpBase = 500;
    
    static let stealBonus = 200.0;
    static let stealPenalty = 100.0;
    
    static let possibleColors = [UIColor(red:0.78, green:0.00, blue:0.49, alpha:1.0),
                                 UIColor(red:0.05, green:0.29, blue:0.73, alpha:1.0),
                                 UIColor(red:0.90, green:0.38, blue:0.08, alpha:1.0),
                                 UIColor(red:0.12, green:0.61, blue:0.00, alpha:1.0)]
    
}
