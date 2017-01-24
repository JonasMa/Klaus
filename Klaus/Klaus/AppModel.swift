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
    
    private(set) var enemiesList: Array<EnemyProfile>;
    private(set) var player: PlayerProfile!
    var scores = [Double]()
    var personalScore: Double!
    var underAttack: Bool = false
    
    init() {
        enemiesList = Array<EnemyProfile>();
        
        //regularly update points based on items
        Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(updatePlayerScore), userInfo: nil, repeats: true);
        
        if let savedPlayer = UserDefaults.standard.object(forKey: "Player") as? Data {
            player = NSKeyedUnarchiver.unarchiveObject(with: savedPlayer) as! PlayerProfile;
            print("PlayerProfile loaded.");
        }else{
            NotificationCenter.default.post(name: NotificationCenterKeys.presentTutorialNotification, object: nil);
            player = PlayerProfile(name: "", items: initialItems());
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
            print("Enemy " + enemy.name + " with id " + enemy.uuid + " removed from list");
            updateEnemyListInView();
        }else{
            print("Could not remove enemy " + enemy.name + " with id " + enemy.uuid + ", not in list");
        }
    }
    
    
    func saveData(){
        let data = NSKeyedArchiver.archivedData(withRootObject: player);
        UserDefaults.standard.removeObject(forKey: "Player");
        UserDefaults.standard.set(data, forKey: "Player");
        print("Data saved.")
    }
    
    //initial items the player gets after first launch
    func initialItems() -> Array<Item>{
        return [CoffeeItem.initNewItem(),CoffeeItem.initNewItem(),AxeItem.initNewItem(),CoffeeItem.initNewItem(),AxeItem.initNewItem(),CoffeeItem.initNewItem(),AxeItem.initNewItem(),AxeItem.initNewItem(),CoffeeItem.initNewItem(),AxeItem.initNewItem(),AxeItem.initNewItem(),CoffeeItem.initNewItem()];
    }

    func triggerEnemyGameInstance(stolenItem: Item) {
        CentralPeripheralController.sharedInstance.sendGameRequestToAtackedPerson(itemToBeStolen: stolenItem)
    }
    
    func triggerIncomingGameFromEnemy(itemToBeStolen: Item) {
        underAttack = true
        NotificationCenter.default.post(name: NotificationCenterKeys.startGameFromEnemyTrigger, object: nil, userInfo: ["item":itemToBeStolen]);
    }
    
    func pushScore(score: Double) {
        scores.append(score)
        if scores.count == winningStatement {
            if ((scores[0] > scores[1]) && (scores[0] == personalScore))||((scores[0] < scores[1]) && (scores[1] == personalScore)){
            //gewonnen
                
            }else{
            //verloren
                
            }
            scores.removeAll()
            underAttack = false
        }
    }
    
    func sendOwnScoreToEnemy(score: Double) {
        CentralPeripheralController.sharedInstance.sendScoreToEnemy(ownScore: score)
    }
    
    func receiveOverallGameResult() {
        //Angegriffener erfährt ob er gewonnen hat oder nicht
    }
    
}

