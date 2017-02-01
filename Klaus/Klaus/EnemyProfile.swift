//
//  EnemyProfile.swift
//  Klaus
//
//  Created by Alex Knittel on 29.12.16.
//  Copyright © 2016 Nimm Swag. All rights reserved.
//

import Foundation

class EnemyProfile: Profile{
    

    var uuid: String

    
    init (name: String, score: Int, uuid: String){
        self.uuid = uuid
        super.init(name: name)
        self.score = score
    }
    
    override init(name: String){
        self.uuid = ""
        super.init(name: name)
        
        //for testing
        self.setItems(items: AppModel.sharedInstance.initialItems());

    }
    
    override func isEqual(_ object: Any?) -> Bool {
        if let object = object as? EnemyProfile {
            return self.uuid == object.uuid;
        }else{
            return false;
        }
    }
    
    func setScore (score: Int){
        self.score = score;
        NotificationCenter.default.post(name: NotificationCenterKeys.updateEnemyLevelNotification, object: nil, userInfo: ["level": score]);
    }
    
    func setItems(items: Array<Item>){
        self.items = items;
        self.updateItemsInView();
    }
    
    func updateItemsInView(){
        var itemDict = Dictionary<Int,Item>();
        if !items.isEmpty{
            for i in 0...(items.count-1){
                itemDict[i] = items[i];
            }
        }
        NotificationCenter.default.post(name: NotificationCenterKeys.updateEnemyItemsNotification, object: nil, userInfo: itemDict)
    }
    
    /*!
     * Compares if the uuid is the same
     *
    func isEqual (profile: EnemyProfile) -> Bool{
        return uuid == profile.uuid
    }
    */
    static func ==(lhs:EnemyProfile, rhs:EnemyProfile) -> Bool { // Implement Equatable
        return lhs.uuid == rhs.uuid
    }
    
}
