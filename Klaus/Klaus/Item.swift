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
    var timeStamp: Date;
    var pointsPerSecond: Int;
    var imageName: String;
    var itemLevel: Int;
    
    static let SEPARATOR: String = "#"
    static let ITEM_SEPARATOR: String = "**"
    
    init(name: String, pointsPerSecond: Int) {
        self.name = name;
        self.pointsPerSecond = pointsPerSecond;
        self.timeStamp = Date() // wer das bisher als NSDate benutzt hat - sorry ;)
        self.imageName = name;
        self.itemLevel = 0;
    }
    
    init(name: String, timeStamp: Date, pointsPerSecond: Int, imageName: String, itemLevel: Int) {
        self.name = name;
        self.pointsPerSecond = pointsPerSecond;
        self.timeStamp = timeStamp
        self.imageName = imageName;
        self.itemLevel = itemLevel;
    }
    
    func toString() -> String {
        var stringy: String
        stringy = name + Item.SEPARATOR + timeStamp.description + Item.SEPARATOR + String(pointsPerSecond)
        return stringy
    }
    
    static func decode (toDecode: String) -> Item? {
        var name: String
        var timeStamp: Date?
        var pointsPerSecond: Int?
        var imageName: String
        var itemLevel: Int?
        
        let splitted = toDecode.components(separatedBy: Item.SEPARATOR)
        
        // check if splitting was successful in terms of length
        if splitted.count < 5 {
            print("decoding Item from String was not possible: Splitted array too short")
            return nil
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd hh:mm:ss.SSSSxxx"
        
        name = splitted[0]
        timeStamp = formatter.date(from: splitted[1])
        pointsPerSecond = Int(splitted[2])
        imageName = splitted[3]
        itemLevel = Int(splitted[4])
        
        // check if unwrapping is safe
        guard timeStamp == timeStamp!
            && pointsPerSecond == pointsPerSecond!
            && itemLevel == itemLevel!
            else {
            return nil
        }
        
        return Item(name: name, timeStamp: timeStamp!, pointsPerSecond: pointsPerSecond!, imageName: imageName, itemLevel: itemLevel!)
    }
}
