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
        
        
        switch test {
        case 2:
            let e1 = EnemyProfile(name: "1 Jorst");
            addEnemyToList(enemy: e1);
            break;
        case 3:
            let e2 = EnemyProfile(name: "2 Barakk");
            addEnemyToList(enemy: e2);
            break;
        case 4:
            let e3 = EnemyProfile(name: "3 Guenther");
            addEnemyToList(enemy: e3);
            break;
        case 5:
            let e4 = EnemyProfile(name: "4 Soeren");
            addEnemyToList(enemy: e4);
            break;
        case 6:
            let e5 = EnemyProfile(name: "5 Heribert");
            addEnemyToList(enemy: e5);
            break;
        case 7:
            let e6 = EnemyProfile(name: "6 Gerlinde");
            addEnemyToList(enemy: e6);
            break;
        case 8:
            let e7 = EnemyProfile(name: "7 Irmgard");
            addEnemyToList(enemy: e7);
            break;

        default: break
            
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

