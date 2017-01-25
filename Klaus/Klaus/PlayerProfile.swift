//
//  PlayerProfile.swift
//  Klaus
//
//  Created by Alex Knittel on 19.12.16.
//  Copyright © 2016 Nimm Swag. All rights reserved.
//

import Foundation

class PlayerProfile: Profile, NSCoding{
    
    
    
    required convenience init(coder aDecoder: NSCoder) {
        self.init(
            name: aDecoder.decodeObject(forKey: "name") as! String,
            items: aDecoder.decodeObject(forKey: "items") as! [Item]);
        }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.name, forKey: "name");
        aCoder.encode(self.items, forKey: "items");
    }


}
