//
//  Profile.swift
//  Klaus
//
//  Created by Alex Knittel on 29.12.16.
//  Copyright © 2016 Nimm Swag. All rights reserved.
//

import Foundation

class Profile: NSObject{
    
    var name: String!;
    var score: Int!;
    private(set) var items: Array<Item>!;
    
    init(name: String, items: Array<Item>){
        super.init();
        self.name = name;
        self.score = 0;
        self.setItems(items: items);
    }
    
    init(name:String){
        super.init();
        self.name = name;
        self.score = 0;
        self.items = [];
    }
    
    func addItem(item: Item){
        items.append(item);
    }
    
    func removeItemWithId(id: String){
        //TODO
    }
    
    func getAcquiredScore() -> Int{
        var score = 0
        for item in items {
            score += item.getAcquiredScore()
        }
        return score;
    }
    
    func getScorePerSecond() -> Int{
        var scorePerSecond = 0;
        for item in items {
            scorePerSecond += item.pointsPerSecond;
        }
        return scorePerSecond;
    }
    
    func setItems(items: Array<Item>){
        self.items = items;
        var itemDict = Dictionary<Int,Item>();
        if !items.isEmpty{
            for i in 0...(items.count-1){
                itemDict[i] = items[i];
            }
        }
        NotificationCenter.default.post(name: NotificationCenterKeys.updateItemsNotification, object: nil, userInfo: itemDict)
    }
    
}
