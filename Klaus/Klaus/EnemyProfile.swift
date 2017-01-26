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
        self.score = score
        super.init(name: name)
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
        NotificationCenter.default.post(name: NotificationCenterKeys.updateEnemyScoreNotification, object: nil, userInfo: ["score": score]);
    }
    
}
