//
//  AppModel.swift
//  Klaus
//
//  Created by Alex Knittel on 29.12.16.
//  Copyright © 2016 Nimm Swag. All rights reserved.
//

import Foundation

class AppModel {
    
    static let sharedInstance: AppModel = AppModel();
    
    var enemiesList: Array<EnemyProfile>;
    let player: PlayerProfile
    
    var test: Int;

    
    init() {
        enemiesList = Array<EnemyProfile>();
        
        //for testing
        player = PlayerProfile(name: "Ulf-Eugen");
        let enemy1 = EnemyProfile(name: "Guenther");
        let enemy2 = EnemyProfile(name: "Soeren");
        enemiesList.append(enemy1);
        enemiesList.append(enemy2);
        
        //to test notifications
        test = 0;
        Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(updateScoreForTesting), userInfo: nil, repeats: true);
        
        
        //load data from NSUserDefaults
    }
    
    @objc func updateScoreForTesting(){
        test += 1;
        NotificationCenter.default.post(name: NotificationCenterKeys.updatePlayerScoreNotification, object: nil, userInfo: ["newScore":String(test)]);
        
        let e1 = EnemyProfile(name: "Jorst");
        let e2 = EnemyProfile(name: "Barakk");
        addEnemyToList(enemy: e1);
        addEnemyToList(enemy: e2);
    }
    
    
    func updateEnemyListInView(){
        var enemyDict = Dictionary<Int,EnemyProfile>();
        
        for i in 0...(enemiesList.count-1){
            enemyDict[i] = enemiesList[i];
        }
        NotificationCenter.default.post(name: NotificationCenterKeys.updateEnemyListNotification, object: nil, userInfo: enemyDict)
    }
    
    func addEnemyToList(enemy: EnemyProfile){
        enemiesList.append(enemy);
        updateEnemyListInView();
    }
    
    func removeEnemyFromList(enemy: EnemyProfile){
        if(enemiesList.contains(enemy)){
            enemiesList.remove(at: enemiesList.index(of: enemy)!);
            print("Enemy " + enemy.name + " with id " + enemy.id + " removed from list");
            updateEnemyListInView();
        }else{
            print("Could not remove enemy " + enemy.name + " with id " + enemy.id + ", not in list");
        }
    }
    
    
    
}

