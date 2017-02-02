//
//  PlayerProfile.swift
//  Klaus
//
//  Created by Alex Knittel on 19.12.16.
//  Copyright © 2016 Nimm Swag. All rights reserved.
//

import Foundation
import UIKit

class PlayerProfile: Profile, NSCoding{
    
    
    required convenience init(coder aDecoder: NSCoder) {
        self.init(
            name: aDecoder.decodeObject(forKey: "name") as! String,
            items: aDecoder.decodeObject(forKey: "items") as! [Item]);
        self.profileColor = UIColor(hexString: aDecoder.decodeObject(forKey: "playerColor") as! String);
        self.profileAvatar = aDecoder.decodeObject(forKey: "avatar") as! String;
        self.score = aDecoder.decodeInteger(forKey: "score");
        self.profileLevel = aDecoder.decodeInteger(forKey: "playerLevel");
        }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.name, forKey: "name");
        aCoder.encode(self.items, forKey: "items");
        aCoder.encode(self.profileColor.toHexString(), forKey: "playerColor");
        aCoder.encode(self.profileAvatar, forKey: "avatar");
        aCoder.encode(self.score!, forKey: "score");
        aCoder.encode(self.profileLevel!,forKey: "playerLevel")
    }

    func addItem(item: Item){
        item.incItemLevel();
        item.resetDate();
        items.append(item);
        self.updateItemsInView()
        NotificationCenter.default.post(name: NotificationCenterKeys.highlightItemNotification, object: nil, userInfo: ["item": item]);
    }
    
    func removeItem(item: Item){
        if(!items.contains(item)){
            print("PRF player does not own Item \(item.id)");
            return;
        }
        items.remove(at: items.index(of: item)!);
        print("PRF item removed with id: " +  String(item.id));
        self.score! += item.getAcquiredScore();//to keep the score generated by the item so far
        self.updateItemsInView();
    }

    
    func updateItemsInView(){
        var itemDict = Dictionary<Int,Item>();
        if !items.isEmpty{
            for i in 0...(items.count-1){
                itemDict[i] = items[i];
            }
        }
        NotificationCenter.default.post(name: NotificationCenterKeys.updatePlayerItemsNotification, object: nil, userInfo: itemDict)
    }

}
