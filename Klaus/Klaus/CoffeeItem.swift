//
//  CoffeeItem.swift
//  Klaus
//
//  Created by Alex Knittel on 21.01.17.
//  Copyright © 2017 Nimm Swag. All rights reserved.
//

import Foundation
import UIKit

class CoffeeItem: Item, NSCoding {
    
    init(){
        super.init(displayName: "Coffee", pointsPerSecond: 2);
    }
    
    init(dateOfAcquisition: Date){
        super.init(displayName: "Coffee", pointsPerSecond: 2, dateOfAcquisition: dateOfAcquisition);
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        self.init(dateOfAcquisition: aDecoder.decodeObject(forKey: "dateOfAcquisition") as! Date);
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(dateOfAcquisition, forKey: "dateOfAcquisition");
    }
    
    override func getGameExplanation() -> String{
        return Strings.shelfGameExplanation;
    }
    
    override func getAssociatedGameViewController() -> UIViewController {
        return ShelfGameViewController(nibName: "ShelfGameViewController", bundle: nil)
    }
}
