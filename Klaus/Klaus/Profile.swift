//
//  Profile.swift
//  Klaus
//
//  Created by Alex Knittel on 29.12.16.
//  Copyright © 2016 Nimm Swag. All rights reserved.
//

import Foundation

class Profile: NSObject{
    
    var id: String;
    var name: String;
    var score: Int;
    var items: Array<Item>;
    
    init(name: String){
        
        //random String for id, temporary
        self.id = String(arc4random_uniform(100000));
        
        self.name = name;
        self.score = 0;
        self.items = [];
        
        
    }
    
    convenience init(id: String, name:String){
        self.init(name: name);
        self.id = id;
        self.items = [];
    }
    
    convenience init(id: String, name: String, items: Array<Item>) {
        self.init(id: id, name: name);
        self.items = items;
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
    
    static func == (lhs: Profile, rhs: Profile) -> Bool{
        return lhs.id == rhs.id;
    }
    
}
