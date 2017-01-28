//
//  PlayerProfile.swift
//  Klaus
//
//  Created by Alex Knittel on 19.12.16.
//  Copyright © 2016 Nimm Swag. All rights reserved.
//

import Foundation
import UIKit

class PlayerProfile: Profile, NSCoding{
    
    
    
    required convenience init(coder aDecoder: NSCoder) {
        self.init(
            name: aDecoder.decodeObject(forKey: "name") as! String,
            items: aDecoder.decodeObject(forKey: "items") as! [Item]);
        self.profileColor = UIColor(hexString: aDecoder.decodeObject(forKey: "playerColor") as! String);
        self.profileAvatar = aDecoder.decodeObject(forKey: "avatar") as! String;
        }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.name, forKey: "name");
        aCoder.encode(self.items, forKey: "items");
        aCoder.encode(self.profileColor.toHexString(), forKey: "playerColor");
        aCoder.encode(self.profileAvatar, forKey: "avatar")
    }


}
