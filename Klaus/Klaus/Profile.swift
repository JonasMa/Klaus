//
//  Profile.swift
//  Klaus
//
//  Created by Alex Knittel on 29.12.16.
//  Copyright © 2016 Nimm Swag. All rights reserved.
//

import Foundation

class Profile: Equatable{
    
    var id: String;
    var name: String;
    var score: Int;
    var items: Array<Item>;
    
    init(name: String){
        
        //random String for id, temporary
        self.id = String(arc4random_uniform(1000));
        
        self.name = name;
        self.score = 123456789;
        self.items = Array<Item>();
        
        //for testing
        let item = Item(name: "Knife", pointsPerSecond: 2);
        self.items = [item,item,item,item,item,item,item,item,item,item,item,item,item,item,item];
        
    }
    
    convenience init(id: String, name:String){
        self.init(name: name);
        self.id = id;
    }
    
    func addItem(item: Item){
        items.append(item);
    }
    
    func removeItemWithId(id: String){
        //TODO
    }
    
    static func == (lhs: Profile, rhs: Profile) -> Bool{
        return lhs.id == rhs.id;
    }
    
}
