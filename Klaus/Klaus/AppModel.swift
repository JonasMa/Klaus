//
//  AppModel.swift
//  Klaus
//
//  Created by Alex Knittel on 29.12.16.
//  Copyright © 2016 Nimm Swag. All rights reserved.
//

import Foundation

class AppModel {
    
    let winningStatement: Int = 2
    static let sharedInstance: AppModel = AppModel();
    
    var enemiesList: Array<EnemyProfile>;
    var player: PlayerProfile!
    var scores = [Double]()
    var personalScore: Double!
    var underAttack: Bool = false
    
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
        let item2 = CoffeeItem();
        let item1 = AxeItem();
        return [item1,item1,item2,item1,item2,item1,item2,item2,item1,item2,item2,item1];
    }
    
    func deleteData(){
        UserDefaults.standard.set(nil, forKey: "Player");
        print("PlayerProfile cleared.");
    }
    
    func triggerEnemyGameInstance(stolenItem: Item) {
        //TODO: Per Bluetooth Item an Gegner senden
        NSLog("Enemy Challenge triggered with item: \(stolenItem.displayName)")
    }
    
    func triggerIncomingGameFromEnemy(itemToBeStolen: Item) {
        underAttack = true
        NotificationCenter.default.post(name: NotificationCenterKeys.startGameFromEnemyTrigger, object: nil, userInfo: ["item":itemToBeStolen]);
    }
    
    func pushScore(score: Double) {
        scores.append(score)
        if scores.count == winningStatement && score == personalScore{ //winning condition
            //TODO: Notify enemy
            NSLog("Gewonnen")
            scores.removeAll()
            underAttack = false
        } else if scores.count == winningStatement && score != personalScore { //losing condition
            //TODO: Notify enemy
            NSLog("Verloren")
            scores.removeAll()
            underAttack = false
        }
        NSLog("Score aus AppModel: \(scores[0])")
    }
    
    func sendOwnScoreAsAffectedPersonToEnemy(score: Double) {
        //Sende score an Challenger
    }
    
    func receiveOverallGameResult() {
        //Angegriffener erfährt ob er gewonnen hat oder nicht
    }
    
}

