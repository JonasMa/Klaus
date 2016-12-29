//
//  AppModel.swift
//  Klaus
//
//  Created by Alex Knittel on 29.12.16.
//  Copyright © 2016 Nimm Swag. All rights reserved.
//

import Foundation

class AppModel: NSObject {
    
    dynamic var enemiesList: Array<EnemyProfile>;
    var player: PlayerProfile;
    
    override init() {
        enemiesList = Array<EnemyProfile>();
        
        //for testing
        player = PlayerProfile(name: "Ulf-Eugen");
        
        super.init()
    }
}
