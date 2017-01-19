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
        Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(updateScoreForTesting), userInfo: nil, repeats: true);
        
        
        //load data from NSUserDefaults
    }
    
    @objc func updateScoreForTesting(){
        test += 1;
        NotificationCenter.default.post(name: NotificationCenterKeys.updatePlayerScoreNotification, object: nil, userInfo: ["newScore":String(test)]);
        
        let e1 = EnemyProfile(name: "Jorst");
        let e2 = EnemyProfile(name: "Barakk");
        let e3 = EnemyProfile(name: "Guenther");
        let e4 = EnemyProfile(name: "Soeren");
        let e5 = EnemyProfile(name: "Heribert");
        let e6 = EnemyProfile(name: "Gerlinde");
        let e7 = EnemyProfile(name: "Irmgard");
        
        switch test {
        case 2:
            addEnemyToList(enemy: e1);
            break;
        case 3:
            addEnemyToList(enemy: e2);
            break;
        case 4:
            addEnemyToList(enemy: e3);
            break;
        case 5:
            addEnemyToList(enemy: e4);
            break;
        case 6:
            addEnemyToList(enemy: e5);
            break;
        case 7:
            addEnemyToList(enemy: e6);
            break;
        case 8:
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

