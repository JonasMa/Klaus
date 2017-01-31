//
//  Profile.swift
//  Klaus
//
//  Created by Alex Knittel on 29.12.16.
//  Copyright © 2016 Nimm Swag. All rights reserved.
//

import Foundation
import UIKit

class Profile: NSObject{
    
    var name: String!;
    var score: Int!;
    var profileColor: UIColor!;
    var profileLevel: Int!;
    var profileAvatar: String!;
    private(set) var items: Array<Item>!;

    
    init(name: String, items: Array<Item>){
        super.init();
        self.name = name;
        self.score = 0;
        self.profileLevel = 1;
        self.profileAvatar = "";
        self.profileColor = UIColor.blue;
        self.setItems(items: items);
    }
    
    init(name:String){
        super.init();
        self.name = name;
        self.score = 0;
        self.profileLevel = 1;
        self.profileAvatar = "";
        self.profileColor = UIColor.blue;
        self.items = [];
    }
    
    func setColor(color: UIColor){
        self.profileColor = color
    }
    
    func setAvatar(avatar: String){
        self.profileAvatar = avatar
    }
    
    func addItem(item: Item){
        item.incItemLevel();
        items.append(item);
        self.updateItemsInView()
    }
    
    func removeItem(item: Item){
        if(!items.contains(item)){
            print("PRF player does not own Item \(item.id)");
            return;
        }
        items.remove(at: items.index(of: item)!);
        print("PRF item removed with id: " +  String(item.id));
        self.updateItemsInView();
    }
    
    func getAcquiredScore() -> Int{
        var sc = self.score!;
        for item in items {
            sc += item.getAcquiredScore()
        }
        return sc;
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
        self.updateItemsInView();
    }
    
    func updateItemsInView(){
        var itemDict = Dictionary<Int,Item>();
        if !items.isEmpty{
            for i in 0...(items.count-1){
                itemDict[i] = items[i];
            }
        }
        NotificationCenter.default.post(name: NotificationCenterKeys.updateItemsNotification, object: nil, userInfo: itemDict)
    }
    
    func getItemsString () -> String{
        var itemStrings = Array<String>()
        for item in items {
            let stringy = item.toString()
            itemStrings.append(stringy)
        }
        
        return itemStrings.joined(separator: Item.ITEM_SEPARATOR)
    }
    
}
