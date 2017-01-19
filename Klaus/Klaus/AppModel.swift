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
        
        //to test notifications
        test = 0;
        Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(updateScoreForTesting), userInfo: nil, repeats: true);
        

        //load data from NSUserDefaults
    }
    
    @objc func updateScoreForTesting(){
        test += 1;
        NotificationCenter.default.post(name: NotificationCenterKeys.updatePlayerScoreNotification, object: nil, userInfo: ["newScore":String(test)]);
        if (test == 3){
            addEnemyToList(enemy: EnemyProfile(name: "Gerlinde"));

        }
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

