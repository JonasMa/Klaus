//
//  EnemyProfile.swift
//  Klaus
//
//  Created by Alex Knittel on 29.12.16.
//  Copyright © 2016 Nimm Swag. All rights reserved.
//

import Foundation

class EnemyProfile: Profile{
    
    var uuid: String

    
    init (name: String, uuid: String){
        self.uuid = uuid
        super.init(name: name)
    }
}
