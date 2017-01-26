//
//  CoffeeItem.swift
//  Klaus
//
//  Created by Alex Knittel on 21.01.17.
//  Copyright © 2017 Nimm Swag. All rights reserved.
//

import Foundation
import UIKit

class CoffeeItem: Item {
    
    private static let IMAGE_NAME = "Coffee";
    
    override init(id: String, displayName: String, pointsPerSecond: Int, dateOfAcquisition: Date, level: Int, itemColor: UIColor){
        super.init(id: id, displayName: displayName, pointsPerSecond: pointsPerSecond, dateOfAcquisition: dateOfAcquisition, level: level, itemColor: itemColor);
        self.imageName = CoffeeItem.IMAGE_NAME;
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        self.imageName = CoffeeItem.IMAGE_NAME;
    }
    
    override func getGameExplanation() -> String{
        return Strings.shelfGameExplanation;
    }
    
    override func getAssociatedGameViewController() -> UIViewController {
        return ShelfGameViewController(nibName: "ShelfGameViewController", bundle: nil)
    }
    
    static func initNewItem() -> Item{
        return CoffeeItem(id: Item.newId(), displayName: "Kaffee", pointsPerSecond: 3, dateOfAcquisition: Date(), level: 1, itemColor: UIColor.blue);
    }
}
