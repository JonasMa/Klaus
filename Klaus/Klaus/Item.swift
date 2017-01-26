//
//  Item.swift
//  Klaus
//
//  Created by Alex Knittel on 19.12.16.
//  Copyright © 2016 Nimm Swag. All rights reserved.
//

import Foundation
import UIKit

class Item: NSObject, NSCoding {
    private(set) var id: String;
    private(set) var displayName: String;
    private(set) var dateOfAcquisition: Date;
    private(set) var pointsPerSecond: Int;
    var imageName: String!;
    private(set) var itemLevel: Int;
    private(set) var itemColor: UIColor;
    
    private static var CURRENT_ID: Int = 0;
    
    static let dateFormat = "yyyy-MM-dd hh:mm:ss.SSSSxxx"
    static let SEPARATOR: String = "#"
    static let ITEM_SEPARATOR: String = "**"
    
    private static let INDEX_ID: Int = 0
    private static let INDEX_NAME: Int = 1
    private static let INDEX_DATE: Int = 2
    private static let INDEX_POINTS: Int = 3
    private static let INDEX_IMAGE: Int = 4
    private static let INDEX_LEVEL: Int = 5
    private static let INDEX_COLOR: Int = 6
    
    private static let NUMBER_OF_PROPERTIES: Int = 7
    
    static let TYPE_ITEM = 0
    static let TYPE_COFFEE = 1
    static let TYPE_ALARM = 2
    static let TYPE_AXE = 3
    static let TYPE_SEITENSCHNEIDER = 4
    var itemType: Int
    
    required init(coder aDecoder: NSCoder) {
        id = aDecoder.decodeObject(forKey: "id") as! String;
        displayName = aDecoder.decodeObject(forKey: "displayName") as! String;
        pointsPerSecond = aDecoder.decodeInteger(forKey: "pointsPerSecond");
        dateOfAcquisition = aDecoder.decodeObject(forKey: "dateOfAcquisition") as! Date;
        itemLevel = aDecoder.decodeInteger(forKey: "level");
        itemType = Item.TYPE_ITEM
        itemColor = UIColor(hexString: aDecoder.decodeObject(forKey: "itemColor") as! String);
    }
  
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id");
        aCoder.encode(displayName, forKey: "displayName");
        aCoder.encode(pointsPerSecond, forKey: "pointsPerSecond");
        aCoder.encode(dateOfAcquisition, forKey: "dateOfAcquisition");
        aCoder.encode(itemLevel, forKey: "level");
        aCoder.encode(itemColor, forKey: "itemLevel");
    }
    
    //do not use
    init(id: String, displayName: String, pointsPerSecond: Int, dateOfAcquisition: Date, level: Int, itemColor: UIColor){
        self.id = id;
        self.displayName = displayName;
        self.pointsPerSecond = pointsPerSecond;
        self.dateOfAcquisition = dateOfAcquisition;
        self.imageName = displayName;
        self.itemLevel = level;
        self.itemColor = itemColor;
        self.itemType = Item.TYPE_ITEM;
    }
    
    func toString() -> String {
        var stringy: String
        let formatter = DateFormatter()
        formatter.dateFormat = Item.dateFormat
        let date: String = formatter.string(from: dateOfAcquisition)
        
        stringy = id + Item.SEPARATOR + displayName + Item.SEPARATOR + date + Item.SEPARATOR + String(pointsPerSecond) + Item.SEPARATOR + imageName + Item.SEPARATOR + String(itemLevel) + Item.SEPARATOR + itemColor.toHexString();
        return stringy
    }
    
    static func decode (toDecode: String) -> Item? {
        var id: String // wie schaut das denn jetzt aus? datenstruktur? was braucht man jetzt?
        var name: String
        var timeStamp: Date?
        var pointsPerSecond: Int?
        //var imageName: String
        var itemLevel: Int?
        var itemColor: UIColor?;
        
        let splitted: [String] = toDecode.components(separatedBy: Item.SEPARATOR)
        
        // check if splitting was successful in terms of length
        if splitted.count < NUMBER_OF_PROPERTIES {
            print("decoding Item from String was not possible: Splitted array too short (\(splitted.count))")
            return nil
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        
        id = splitted[INDEX_ID]
        name = splitted[INDEX_NAME]
        timeStamp = formatter.date(from: splitted[INDEX_DATE])
        pointsPerSecond = Int(splitted[INDEX_POINTS])
        //imageName = splitted[INDEX_NAME]
        itemLevel = Int(splitted[INDEX_LEVEL])
        itemColor = UIColor(hexString: splitted[INDEX_COLOR]);
        
        // check if unwrapping is safe
        if timeStamp == nil
            || pointsPerSecond == nil
            || itemLevel == nil {
            print("unwrapping Item.decode was unsuccesful")
        }
        
        //workaround LUL
        switch name {
        case "Axe":
            return AxeItem(id: id, displayName: name, pointsPerSecond: pointsPerSecond!, dateOfAcquisition: timeStamp!, level: itemLevel!, itemColor: itemColor!);
        case "Coffee":
            return CoffeeItem(id: id, displayName: name, pointsPerSecond: pointsPerSecond!, dateOfAcquisition: timeStamp!, level: itemLevel!, itemColor: itemColor!);
        default:
                print("unknown displayname");
                return nil;
        }
//        return Item(id: id, displayName: name, pointsPerSecond: pointsPerSecond!, dateOfAcquisition: timeStamp!, level: itemLevel!)
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
    
    static func newId() -> String{
        let id = String(format: "%04d", CURRENT_ID);
        CURRENT_ID += 1;
        return (UIDevice.current.identifierForVendor?.uuidString)! +  id;
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        if let object = object as? Item {
            return self.id == object.id;
        }else{
            return false;
        }
    }
    
    
}
