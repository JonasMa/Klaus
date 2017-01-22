//
//  EnemyProfile.swift
//  Klaus
//
//  Created by Alex Knittel on 29.12.16.
//  Copyright © 2016 Nimm Swag. All rights reserved.
//

import Foundation

class EnemyProfile: Profile{
    
    override init(name: String){
        super.init(name: name);
        
        //for testing
        self.items = AppModel.sharedInstance.initialItems();
    }
}
