//
//  AppModel.swift
//  Klaus
//
//  Created by Alex Knittel on 29.12.16.
//  Copyright © 2016 Nimm Swag. All rights reserved.
//

import Foundation
import UIKit
import AudioToolbox

class AppModel {
    
    static let sharedInstance: AppModel = AppModel();
    
    private(set) var enemiesList: Array<EnemyProfile>;
    private(set) var player: PlayerProfile!
    //var scores = [Double]()
    var personalScore: Double?
    var enemyScore: Double?
    var underAttack: Bool = false
    var isAttacking: Bool = false
    var attackedItem: Item!

    
    init() {
        enemiesList = Array<EnemyProfile>();
        
        //regularly update points based on items
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updatePlayerStats), userInfo: nil, repeats: true);
        
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
        let enemy = getEnemyByUuid(uuid: uuid)
        enemy?.setItems(items: items)
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
    
    func removeEnemyFromList(enemyUuid: String){
        let enemy = EnemyProfile(name: "", score: 0, uuid: enemyUuid)
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
    func triggerEnemyGameInstance(stolenItem: Item, onPlayerUuuidString uuid: String) {
        resetScores()
        BluetoothController.sharedInstance.sendGameRequestToAtackedPerson(itemToBeStolen: stolenItem, onPlayerUuuidString: uuid)
    }
    
    func triggerIncomingGameFromEnemy(itemToBeStolen: Item) {
        resetScores()
        underAttack = true
        attackedItem = itemToBeStolen
        NotificationCenter.default.post(name: NotificationCenterKeys.startGameFromEnemyTrigger, object: nil, userInfo: ["item":itemToBeStolen]);
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
    }
    
    func pushPersonalScore(score: Double){
        print("AM push personal score \(score)")
        self.personalScore = score;
        BluetoothController.sharedInstance.sendScoreToEnemy(score: score);
        if(enemyScore != nil){
            Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(sendGameResultMessages), userInfo: nil, repeats: false);
        }
    }
    
    func pushScore(score: Double){
        self.enemyScore = score;
        if(personalScore != nil){
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
        print("AM personal score: \(personalScore) ,enemyScore: \(enemyScore)");
        if (personalScore == nil || enemyScore == nil){
            print("ERROR (was fatal): score is nil in sendGameresultMessages \(personalScore) \(enemyScore)");
        }

        if (personalScore! > enemyScore!){
            let bonus = Int((1 - enemyScore!/personalScore!) * Config.stealBonus);
            player.score! += bonus
            if underAttack { // Item verteidigt
                
            }else{ //Item gewonnen
                displayAlertFor(resultType: .successfulAttack, score1: personalScore!, score2: enemyScore!, scoreChange: bonus, item: attackedItem)
                self.player.addItem(item: attackedItem);
            }
            
        }else if (enemyScore! > personalScore!){
            let penalty = Int((1 - personalScore!/enemyScore!) * Config.stealBonus);
            player.score! -= penalty
            if underAttack { // Item verloren
                displayAlertFor(resultType: .failedDefense, score1: personalScore!, score2: enemyScore!, scoreChange: penalty, item: attackedItem)
                self.player.removeItem(item: attackedItem);
            }else{ // Item nicht gewonnen
                displayAlertFor(resultType: .failedAttack, score1: personalScore!, score2: enemyScore!, scoreChange: penalty, item: attackedItem)
            }
        }else if (personalScore! == enemyScore!){
            if underAttack {
                displayAlertFor(resultType: .successfulDefense, score1: personalScore!, score2: enemyScore!, scoreChange: 0, item: attackedItem)
            }else{
                displayAlertFor(resultType: .failedAttack, score1: personalScore!, score2: enemyScore!, scoreChange: 0, item: attackedItem)
            }
        }
        resetScores()
        underAttack = false
        isAttacking = false
        attackedItem = nil
        BluetoothController.sharedInstance.onGameFinish()
    }
    
    func resetScores() {
        personalScore = nil;
        enemyScore = nil;
    }
    
    
    private func scoreBonus(value: Double){
        player.score! += Int(value * Config.stealBonus);
        print("AM Player won by a factor of \(value), granting \(value * Config.stealBonus) points");
    }
    
    private func scorePenalty(value: Double){
        player.score! -= Int(value * Config.stealPenalty);
        print("AM Player lost by a factor of \(value), removing \(value * Config.stealBonus) points");
    }
    
    private func displayAlertFor(resultType: ResultType, score1: Double, score2: Double, scoreChange: Int, item: Item){
        switch resultType {
        case .successfulAttack:
            let resultString = "\n\(Strings.successfullAttack)\n\n\(Int(score1)) : \(Int(score2))\n\n\(scoreChange) Bonuspunkte\n\n Die \(item.displayName) gehört jetzt dir!";
            displayAlert(title: Strings.gratulation, message: resultString, buttonTitle: Strings.happyConfirmation)
        case .successfulDefense:
            let resultString = "\n\(Strings.successfullDefense)\n\n\(Int(score1)) : \(Int(score2))\n\n\(scoreChange) Bonuspunkte\n\n Die \(item.displayName) behältst du!";
            displayAlert(title: Strings.gratulation, message: resultString, buttonTitle: Strings.happyConfirmation)
        case .failedAttack:
            let resultString = "\n\(Strings.failedAttack)\n\n\(Int(score1)) : \(Int(score2))\n\n\(scoreChange) Minuspunkte\n\n Die \(item.displayName) bekommst du nicht!";
            displayAlert(title: Strings.fail, message: resultString, buttonTitle: Strings.sadConfirmation)
        case .failedDefense:
            let resultString = "\n\(Strings.successfullAttack)\n\n\(Int(score1)) : \(Int(score2))\n\n\(scoreChange) Minuspunkte\n\n Die \(item.displayName) ist halt jetzt weg...";
            displayAlert(title: Strings.fail, message: resultString, buttonTitle: Strings.sadConfirmation)
        }
    }
    
    func isGaming() -> Bool {
        print("AM underAttack: \(underAttack), isAttacking\(isAttacking)")
        return underAttack || isAttacking
    }
    
    func onGameStatusReceived(everythingOk: Bool) {
        if everythingOk {
            NotificationCenter.default.post(name: NotificationCenterKeys.startGame, object: nil);
        }else{
            displayAlert(title: Strings.statusNotOkTitle, message: Strings.statusNotOkMessage, buttonTitle: Strings.statusNotOkButton)
        }
    }
    
    enum ResultType{
        case successfulDefense
        case successfulAttack
        case failedDefense
        case failedAttack
    }
}



