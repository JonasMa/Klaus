//
//  AlarmItem.swift
//  Klaus
//
//  Created by admin on 25.01.17.
//  Copyright © 2017 Nimm Swag. All rights reserved.
//

import Foundation
import UIKit

class AlarmItem: Item {
    
    private static let IMAGE_NAME = "Alarm";

    override init(id: String, displayName: String, pointsPerSecond: Int, dateOfAcquisition: Date, level: Int, itemColor: UIColor){
        super.init(id: id, displayName: displayName, pointsPerSecond: pointsPerSecond, dateOfAcquisition: dateOfAcquisition, level: level, itemColor: itemColor);
        self.imageName = AlarmItem.IMAGE_NAME;
        self.itemType = Item.TYPE_ALARM
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        self.imageName = AlarmItem.IMAGE_NAME;
        self.itemType = Item.TYPE_ALARM
    }
    
    override func getGameExplanation() -> String{
        return Strings.simonSaysExplanation;
    }
    
    override func getAssociatedGameViewController() -> UIViewController {
        return SimonSaysViewController(nibName: "SimonSaysViewController", bundle: nil) as UIViewController;
    }
    
    static func initNewItem() -> Item{
        return AlarmItem(id: Item.newId(), displayName: "Alarm", pointsPerSecond: Config.alarmBasePointsPerSecond, dateOfAcquisition: Date(), level: 1, itemColor: Item.getRandomItemColor());
    }
    
    override func getInfoString() -> String{
        return Strings.alarmInfo;
    }
}
