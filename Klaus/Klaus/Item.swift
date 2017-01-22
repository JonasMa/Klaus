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
    static let dateFormat = "yyyy-MM-dd hh:mm:ss.SSSSxxx"
    static let SEPARATOR: String = "#"
    static let ITEM_SEPARATOR: String = "**"
    
    private static let INDEX_ID: Int = 0
    private static let INDEX_NAME: Int = 1
    private static let INDEX_DATE: Int = 2
    private static let INDEX_POINTS: Int = 3
    private static let INDEX_IMAGE: Int = 4
    private static let INDEX_LEVEL: Int = 5
    
  
    
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
    
    init(displayName: String, pointsPerSecond: Int, dateOfAcquisition: Date, level: Int){
        self.id = displayName;
        self.displayName = displayName;
        self.pointsPerSecond = pointsPerSecond;
        self.dateOfAcquisition = dateOfAcquisition;
        self.imageName = displayName;
        self.itemLevel = 0;
    }
    
    func toString() -> String {
        var stringy: String
        let formatter = DateFormatter()
        formatter.dateFormat = Item.dateFormat
        let date: String = formatter.string(from: dateOfAcquisition)
        
        stringy = id + Item.SEPARATOR + displayName + Item.SEPARATOR + date + Item.SEPARATOR + String(pointsPerSecond) + Item.SEPARATOR + imageName + Item.SEPARATOR + String(itemLevel)
        return stringy
    }
    
    static func decode (toDecode: String) -> Item? {
        //var id: String // wie schaut das denn jetzt aus? datenstruktur? was braucht man jetzt?
        var name: String
        var timeStamp: Date?
        var pointsPerSecond: Int?
        //var imageName: String
        var itemLevel: Int?
        
        let splitted: [String] = toDecode.components(separatedBy: Item.SEPARATOR)
        
        // check if splitting was successful in terms of length
        if splitted.count < 6 {
            print("decoding Item from String was not possible: Splitted array too short (\(splitted.count))")
            return nil
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        
        //id = splitted[INDEX_ID]
        name = splitted[INDEX_NAME]
        timeStamp = formatter.date(from: splitted[INDEX_DATE])
        pointsPerSecond = Int(splitted[INDEX_POINTS])
        //imageName = splitted[INDEX_NAME]
        itemLevel = Int(splitted[INDEX_LEVEL])
        
        // check if unwrapping is safe
        guard timeStamp != nil
            && pointsPerSecond != nil
            && itemLevel != nil
            else {
            print("unwrapping Item.decode was unsuccesful")
            return nil
        }
        return Item(displayName: name, pointsPerSecond: pointsPerSecond!, dateOfAcquisition: timeStamp!, level: itemLevel!)
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
