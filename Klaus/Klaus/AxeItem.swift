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
    
    private static let IMAGE_NAME = "axti";
    
    override init(id: String, displayName: String, pointsPerSecond: Int, dateOfAcquisition: Date, level: Int, itemColor: UIColor){
        super.init(id: id, displayName: displayName, pointsPerSecond: pointsPerSecond, dateOfAcquisition: dateOfAcquisition, level: level, itemColor: itemColor);
        self.imageName = AxeItem.IMAGE_NAME;
        self.itemType = Item.TYPE_AXE;
        
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        self.imageName = AxeItem.IMAGE_NAME;
        self.itemType = Item.TYPE_AXE;
    }
    
    override func getGameExplanation() -> String{
        return Strings.axeGameExplanation;
    }
    
    override func getAssociatedGameViewController() -> UIViewController {
        return AxeGameViewController(nibName: "AxeGameViewController", bundle: nil) as UIViewController;
    }
    
    static func initNewItem() -> Item{
        return AxeItem(id: Item.newId(), displayName: "Axti", pointsPerSecond: Config.axeBasePointsPerSecond, dateOfAcquisition: Date(), level: 1, itemColor: Item.getRandomItemColor());
    }
    
    override func getInfoString() -> String{
        return Strings.axeInfo;
    }
}
