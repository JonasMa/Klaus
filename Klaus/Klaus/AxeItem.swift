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
    
    private static let IMAGE_NAME = "Axe";
    
    override init(id: String, displayName: String, pointsPerSecond: Int, dateOfAcquisition: Date, level: Int){
        super.init(id: id, displayName: displayName, pointsPerSecond: pointsPerSecond, dateOfAcquisition: dateOfAcquisition, level: level);
        self.imageName = AxeItem.IMAGE_NAME;
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        self.imageName = AxeItem.IMAGE_NAME;
    }
    
    override func getGameExplanation() -> String{
        return Strings.axeGameExplanation;
    }
    
    override func getAssociatedGameViewController() -> UIViewController {
        return AxeGameViewController(nibName: "AxeGameViewController", bundle: nil) as UIViewController;
    }
    
    static func initNewItem() -> Item{
        return AxeItem(id: Item.newId(), displayName: "Axt", pointsPerSecond: 2, dateOfAcquisition: Date(), level: 1);
    }
}
