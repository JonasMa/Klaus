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
    var items: Array<Item>!;

    
    init(name: String, items: Array<Item>){
        super.init();
        self.name = name;
        self.score = 0;
        self.profileLevel = 1;
        self.profileAvatar = "";
        self.profileColor = UIColor.blue;
        self.items = items;
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
    
    
    func getItemsString () -> String{
        var itemStrings = Array<String>()
        for item in items {
            let stringy = item.toString()
            itemStrings.append(stringy)
        }
        
        return itemStrings.joined(separator: Item.ITEM_SEPARATOR)
    }
    
}
