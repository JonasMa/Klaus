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
    var player: PlayerProfile!
    
    init() {
        enemiesList = Array<EnemyProfile>();
        
        //update points based on items
        Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(updatePlayerScore), userInfo: nil, repeats: true);
        
        if let savedPlayer = UserDefaults.standard.object(forKey: "Player") as? Data {
            player = NSKeyedUnarchiver.unarchiveObject(with: savedPlayer) as! PlayerProfile;
            print("PlayerProfile loaded.");
        }else{
            NotificationCenter.default.post(name: NotificationCenterKeys.presentTutorialNotification, object: nil);
            player = PlayerProfile(id: "0", name: "", items: initialItems());
            print("new Profile created, presenting tutorialView.");
        }
        
    }

    
    @objc func updatePlayerScore(){
        NotificationCenter.default.post(name: NotificationCenterKeys.updatePlayerScoreNotification, object: nil, userInfo: ["score":String(player.getAcquiredScore()),"scorePerSecond": String(player.getScorePerSecond())]);
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
    
    func saveData(){
        let data = NSKeyedArchiver.archivedData(withRootObject: player);
        UserDefaults.standard.set(data, forKey: "Player");
        print("Data saved.")
                
    }
    
    func initialItems() -> Array<Item>{
        return [CoffeeItem.initNewItem(),CoffeeItem.initNewItem(),AxeItem.initNewItem(),CoffeeItem.initNewItem(),AxeItem.initNewItem(),CoffeeItem.initNewItem(),AxeItem.initNewItem(),AxeItem.initNewItem(),CoffeeItem.initNewItem(),AxeItem.initNewItem(),AxeItem.initNewItem(),CoffeeItem.initNewItem()];
    }
    
    func deleteData(){
        UserDefaults.standard.set(nil, forKey: "Player");
        print("PlayerProfile cleared.");
    }
    
    
    
}

