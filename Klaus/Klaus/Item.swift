//
//  Item.swift
//  Klaus
//
//  Created by Alex Knittel on 19.12.16.
//  Copyright © 2016 Nimm Swag. All rights reserved.
//

import Foundation
import UIKit

class Item {
    var id: String;
    var displayName: String;
    var dateOfAcquisition: Date;
    var pointsPerSecond: Int;
    var imageName: String;
    var itemLevel: Int;
    
    init(displayName: String, pointsPerSecond: Int) {
        self.id = displayName;
        self.displayName = displayName;
        self.pointsPerSecond = pointsPerSecond;
        self.dateOfAcquisition = Date()
        self.imageName = displayName;
        self.itemLevel = 0;
    }
    
    func getGameExplanation() -> String{
        preconditionFailure("This function must be overridden!");
    }
    
    func getAssociatedGameViewController() -> UIViewController{
        preconditionFailure("This function must be overridden!");
    }
    
    func getAcquiredScore() -> Int{
        let interval = dateOfAcquisition.timeIntervalSinceNow;
        return abs(Int(interval) * pointsPerSecond);
    }
    
}
