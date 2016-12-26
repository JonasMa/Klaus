//
//  Item.swift
//  Klaus
//
//  Created by Alex Knittel on 19.12.16.
//  Copyright © 2016 Nimm Swag. All rights reserved.
//

import Foundation

class Item {
    var name: String;
    var timeStamp: NSDate;
    var pointsPerSecond: Int;
    
    init(name: String, pointsPerSecond: Int) {
        self.name = name;
        self.pointsPerSecond = pointsPerSecond;
        self.timeStamp = NSDate()
    }
}
