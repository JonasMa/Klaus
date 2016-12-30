//
//  Games.swift
//  Klaus
//
//  Created by Oliver Pieper on 29.12.16.
//  Copyright © 2016 Nimm Swag. All rights reserved.
//

import Foundation

class Games {
    var id: Int
    var name: String
    var description: String
    
    
    init(gameId: Int, gameName: String, gameDesc: String) {
        self.id = gameId
        self.name = gameName
        self.description = gameDesc
    }
    
}
