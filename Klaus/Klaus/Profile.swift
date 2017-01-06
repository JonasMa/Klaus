//
//  Profile.swift
//  Klaus
//
//  Created by Alex Knittel on 29.12.16.
//  Copyright © 2016 Nimm Swag. All rights reserved.
//

import Foundation

class Profile {
    
    var name: String;
    var score: Int;
    var items: Array<Item>;
    
    init(name: String){
        self.name = name;
        self.score = 1337;
        self.items = Array<Item>();
        
        //for testing
        let item = Item(name: "Knife", pointsPerSecond: 2);
        self.items = [item,item,item,item,item,item,item,item,item,item,item,item,item,item,item];
        
    }
    
    func addItem(item: Item){
        items.append(item);
    }
    
    func removeItemWithId(id: String){
        //TODO
    }
    
}
