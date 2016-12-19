//
//  Player.swift
//  Klaus
//
//  Created by Alex Knittel on 19.12.16.
//  Copyright © 2016 Nimm Swag. All rights reserved.
//

import Foundation

class Player {
    var name: String;
    var score: Int;
    var items: Array<Item>;
    
    init(name: String) {
        self.name = name;
        self.score = 0;
        
        //for testing
        let item1 = Item(name: "Knife");
        let item2 = Item(name: "Lockpick");
        self.items = [item1,item2];
    }
}
