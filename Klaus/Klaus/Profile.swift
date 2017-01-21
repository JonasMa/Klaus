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
        self.id = String(arc4random_uniform(100000));
        
        self.name = name;
        self.score = 0;
        self.items = Array<Item>();
        
        //for testing
        let item2 = CoffeeItem();
        let item1 = AxeItem();
        self.items = [item1,item1,item2,item1,item2,item1,item2,item2,item1,item2,item2,item1,item1,item1,item1];
        
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
