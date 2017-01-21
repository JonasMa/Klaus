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
    
    init(){
        super.init(displayName: "Coffee", pointsPerSecond: 7);
    }
    
    override func getGameExplanation() -> String{
        return Strings.shelfGameExplanation;
    }
    
    override func getAssociatedGameViewController() -> UIViewController {
        return ShelfGameViewController(nibName: "ShelfGameViewController", bundle: nil)
    }
}
