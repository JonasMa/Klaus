//
//  AxeItem.swift
//  Klaus
//
//  Created by Alex Knittel on 21.01.17.
//  Copyright © 2017 Nimm Swag. All rights reserved.
//

import Foundation
import UIKit

class AxeItem: Item {
    
    init(){
        super.init(displayName: "Axe", pointsPerSecond: 5);
    }
    
    override func getGameExplanation() -> String{
        return Strings.axeGameExplanation;
    }
    
    override func getAssociatedGameViewController() -> UIViewController {
        return AxeGameViewController(nibName: "AxeGameViewController", bundle: nil) as UIViewController;
    }
}
