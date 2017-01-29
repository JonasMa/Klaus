//
//  AppModel.swift
//  Klaus
//
//  Created by Alex Knittel on 29.12.16.
//  Copyright © 2016 Nimm Swag. All rights reserved.
//

import Foundation
import UIKit

class AppModel {
    
    let winningStatement: Int = 2
    static let sharedInstance: AppModel = AppModel();
    
    private(set) var enemiesList: Array<EnemyProfile>;
    private(set) var player: PlayerProfile!
    var scores = [Double]()
    var personalScore: Double!
    var underAttack: Bool = false
    var attackedItem: Item!
    
    init() {
        enemiesList = Array<EnemyProfile>();
        
        //regularly update points based on items
        Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(updatePlayerStats), userInfo: nil, repeats: true);
        
        if let savedPlayer = UserDefaults.standard.object(forKey: "Player") as? Data {
            player = NSKeyedUnarchiver.unarchiveObject(with: savedPlayer) as! PlayerProfile;
            print("PlayerProfile loaded.");
        }else{
            NotificationCenter.default.post(name: NotificationCenterKeys.presentTutorialNotification, object: nil);
            player = PlayerProfile(name: "", items: initialItems());
            print("new Profile created, presenting tutorialView.");
        }
    }

    
    @objc func updatePlayerStats(){
        NotificationCenter.default.post(name: NotificationCenterKeys.updatePlayerScoreNotification, object: nil, userInfo: ["score":String(player.getAcquiredScore()),"scorePerSecond": String(player.getScorePerSecond())]);
        if checkPlayerLevelUp(){
            NotificationCenter.default.post(name: NotificationCenterKeys.updatePlayerLevelNotification, object: nil, userInfo: ["level": String(player.profileLevel)]);
        }
        
    }
    
    func updateEnemyListInView(){
        var enemyDict = Dictionary<Int,EnemyProfile>();
        for i in 0...(enemiesList.count-1){
            enemyDict[i] = enemiesList[i];
        }
        NotificationCenter.default.post(name: NotificationCenterKeys.updateEnemyListNotification, object: nil, userInfo: enemyDict)
    }
    
    func checkPlayerLevelUp() -> Bool{
        let scoreNeeded = Config.scoreToLevelUpBase * player.profileLevel * (1 + player.profileLevel)
        if player.getAcquiredScore() >= scoreNeeded {
            player.profileLevel! += 1;
            return true;
        }
        return false;
    }
    
    func addEnemyToList(enemy: EnemyProfile){
        enemiesList.append(enemy);
        updateEnemyListInView();
    }
    
    func updateEnemyItemsInList(items: [Item], uuid: String){

        getEnemyByUuid(uuid: uuid)?.setItems(items: items)
        print("update enemy items")
        updateEnemyListInView()
    }
    
    private func getEnemyByUuid(uuid: String) -> EnemyProfile? {
        for enemy in enemiesList {
            if enemy.uuid == uuid {
                return enemy
            }
        }
        return nil
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
        return [CoffeeItem.initNewItem(),
                AxeItem.initNewItem(),
                SeitenschneiderItem.initNewItem(),
                CoffeeItem.initNewItem(),
                AlarmItem.initNewItem(),
                AxeItem.initNewItem(),
                AlarmItem.initNewItem(),
                SeitenschneiderItem.initNewItem(),
                AxeItem.initNewItem(),
                CoffeeItem.initNewItem()];
    }

    
    //(callback)functions used for delegating game impulses, determining winning statement
    func triggerEnemyGameInstance(stolenItem: Item) {
        BluetoothController.sharedInstance.sendGameRequestToAtackedPerson(itemToBeStolen: stolenItem)
    }
    
    func triggerIncomingGameFromEnemy(itemToBeStolen: Item) {
        underAttack = true
        attackedItem = itemToBeStolen
        NotificationCenter.default.post(name: NotificationCenterKeys.startGameFromEnemyTrigger, object: nil, userInfo: ["item":itemToBeStolen]);
        //TODO: Hinweis, dass man angegriffen wurde
    }
    
    func pushScore(score: Double) {
        scores.append(score)
        NSLog("Personal Score AppModel: \(personalScore)")
        if scores.count == winningStatement {
            Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(sendGameResultMessages), userInfo: nil, repeats: false);
        }
    }
    
    func sendOwnScoreToEnemy(score: Double) {
        BluetoothController.sharedInstance.sendScoreToEnemy(score: score)
    }
    
    func displayAlert(title: String, message: String, buttonTitle: String) {
                NotificationCenter.default.post(name: NotificationCenterKeys.showAlertNotification, object: nil, userInfo: ["title": title,"message": message, "buttonTitle": buttonTitle]);
    }
    
    @objc func sendGameResultMessages(){
        if ((scores[0] > scores[1]) && (scores[0] == personalScore))||((scores[0] < scores[1]) && (scores[1] == personalScore)){
            //gewonnen
            if underAttack { // Item Verteidigt
                displayAlert(title: Strings.gratulation, message: Strings.successfullDefense, buttonTitle: Strings.happyConfirmation)
            }else{ //Item gewonnen
                displayAlert(title: Strings.gratulation, message: Strings.successfullAttack, buttonTitle: Strings.happyConfirmation)
                self.player.addItem(item: attackedItem);
                //TODO: Erhalte/behalte Item
            }
        }else if ((scores[0] > scores[1]) && (scores[0] != personalScore))||((scores[0] < scores[1]) && (scores[1] != personalScore)){
            //verloren
            if underAttack { // Item verloren
                displayAlert(title: Strings.fail, message: Strings.failedDefense, buttonTitle: Strings.sadConfirmation)
                self.player.removeItem(item: attackedItem);
                //TODO: Gib das Item ab / lösche es aus deinem Profil
            }else{ //Item konnte nicht gewonnen werden
                displayAlert(title: Strings.fail, message: Strings.failedAttack, buttonTitle: Strings.sadConfirmation)
            }
        }else if (scores[0] == scores[1]){
            //unentschieden
            if underAttack {
                displayAlert(title: Strings.gratulation, message: Strings.successfullDefense, buttonTitle: Strings.happyConfirmation)
            }else{
                displayAlert(title: Strings.fail, message: Strings.failedAttack, buttonTitle: Strings.sadConfirmation)
            }
        }
        scores.removeAll()
        underAttack = false
        NSLog("Item ID: \(attackedItem.id)")
        NSLog("Scores: \(scores)")
    }
}

