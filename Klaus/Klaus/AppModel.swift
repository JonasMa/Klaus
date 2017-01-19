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

    
    init() {
        enemiesList = Array<EnemyProfile>();
        
        //for testing
        player = PlayerProfile(name: "Ulf-Eugen");
        let enemy1 = EnemyProfile(name: "Guenther");
        let enemy2 = EnemyProfile(name: "Soeren");
        enemiesList.append(enemy1);
        enemiesList.append(enemy2);
        
        
        Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(updateScoreTest), userInfo: nil, repeats: false);
        //load data from NSUserDefaults
    }
    
    @objc func updateScoreTest(){
        print("test")
    }
    
    
    func updateEnemyList(enemiesList: Array<EnemyProfile>){
        self.enemiesList = enemiesList;
    }
    
    func addEnemyToList(enemy: EnemyProfile){
        enemiesList.append(enemy)
        
    }
    
}
