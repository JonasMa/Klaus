//
//  Item.swift
//  Klaus
//
//  Created by Alex Knittel on 19.12.16.
//  Copyright © 2016 Nimm Swag. All rights reserved.
//

import Foundation
import UIKit

class Item: NSObject /*,NSCoding+*/ {
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
    
    init(displayName: String, pointsPerSecond: Int, dateOfAcquisition: Date){
        self.id = displayName;
        self.displayName = displayName;
        self.pointsPerSecond = pointsPerSecond;
        self.dateOfAcquisition = dateOfAcquisition;
        self.imageName = displayName;
        self.itemLevel = 0;
    }
    
//    required convenience init(coder aDecoder: NSCoder) {
//        self.init(
//            displayName: aDecoder.decodeObject(forKey: "displayName") as! String,
//            pointsPerSecond: aDecoder.decodeInteger(forKey: "pointsPerSecond"));
//    }
//    
//    func encode(with aCoder: NSCoder) {
//        aCoder.encode(self.displayName, forKey: "displayName");
//        aCoder.encode(self.pointsPerSecond, forKey: "pointsPerSecond");
//    }
    
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
