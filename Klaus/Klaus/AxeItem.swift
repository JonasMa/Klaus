//
//  AxeItem.swift
//  Klaus
//
//  Created by Alex Knittel on 21.01.17.
//  Copyright © 2017 Nimm Swag. All rights reserved.
//

import Foundation
import UIKit

class AxeItem: Item, NSCoding {
    
    init(){
        super.init(displayName: "Axe", pointsPerSecond: 1);
    }
    
    init(dateOfAcquisition: Date){
        super.init(displayName: "Axe", pointsPerSecond: 1, dateOfAcquisition: dateOfAcquisition);

    }
    
    required convenience init(coder aDecoder: NSCoder) {
        self.init(dateOfAcquisition: aDecoder.decodeObject(forKey: "dateOfAcquisition") as! Date);
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(dateOfAcquisition, forKey: "dateOfAcquisition");
    }
    
    override func getGameExplanation() -> String{
        return Strings.axeGameExplanation;
    }
    
    override func getAssociatedGameViewController() -> UIViewController {
        return AxeGameViewController(nibName: "AxeGameViewController", bundle: nil) as UIViewController;
    }
}
