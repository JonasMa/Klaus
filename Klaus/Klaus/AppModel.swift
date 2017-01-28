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
    
    var updateToNextLevel = 1000
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
        Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(updatePlayerScore), userInfo: nil, repeats: true);
        
        if let savedPlayer = UserDefaults.standard.object(forKey: "Player") as? Data {
            player = NSKeyedUnarchiver.unarchiveObject(with: savedPlayer) as! PlayerProfile;
            if let savedAvatar = UserDefaults.standard.object(forKey: "PlayerAvatar") as? String {
                player.profileAvatar = savedAvatar
            }
            if let savedColor = UserDefaults.standard.object(forKey: "PlayerColor") as? Data{
                player.profileColor = NSKeyedUnarchiver.unarchiveObject(with: savedColor) as? UIColor;
            }
            print("PlayerProfile loaded.");
        }else{
            NotificationCenter.default.post(name: NotificationCenterKeys.presentTutorialNotification, object: nil);
            player = PlayerProfile(name: "", items: initialItems());
            print("new Profile created, presenting tutorialView.");
        }
    }

    
    @objc func updatePlayerScore(){
        NotificationCenter.default.post(name: NotificationCenterKeys.updatePlayerScoreNotification, object: nil, userInfo: ["score":String(player.score + player.getAcquiredScore()),"scorePerSecond": String(player.getScorePerSecond())]);
        updatePlayerLevel()
    }
    
    @objc func updatePlayerLevel(){
        let scoreNeededForNextLevel = updateToNextLevel * player.profileLevel * (1 + player.profileLevel)
        if player.getAcquiredScore() >= scoreNeededForNextLevel {
            let newLevel = player.profileLevel + 1
            NotificationCenter.default.post(name: NotificationCenterKeys.updatePlayerLevelNotification, object: nil, userInfo: ["level":String(newLevel)]);
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
            print("Enemy " + enemy.name + " with id " + enemy.uuid + " removed from list");
            updateEnemyListInView();
        }else{
            print("Could not remove enemy " + enemy.name + " with id " + enemy.uuid + ", not in list");
        }
    }
    
    
    func saveData(){
        // level, farbe, und avatar müssen noch gespeichert werden
        let data = NSKeyedArchiver.archivedData(withRootObject: player);
        UserDefaults.standard.removeObject(forKey: "Player");
        UserDefaults.standard.set(data, forKey: "Player");
        
        UserDefaults.standard.removeObject(forKey: "PlayerAvatar");
        UserDefaults.standard.set(player.profileAvatar, forKey: "PlayerAvatar")
        
        let colorData = NSKeyedArchiver.archivedData(withRootObject: player.profileColor);
        UserDefaults.standard.removeObject(forKey: "PlayerColor");
        UserDefaults.standard.set(colorData, forKey: "PlayerColor")
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
        CentralPeripheralController.sharedInstance.sendGameRequestToAtackedPerson(itemToBeStolen: stolenItem)
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
        CentralPeripheralController.sharedInstance.sendScoreToEnemy(ownScore: score)
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

