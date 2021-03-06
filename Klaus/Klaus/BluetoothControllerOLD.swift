//
//  BluetoothController.swift
//  Klaus
//
//  Created by Jonas Programmierer on 15.01.17.
//  Copyright © 2017 Nimm Swag. All rights reserved.
//

import Foundation
import CoreBluetooth

private class BluetoothControllerOLD: CentralDelegate, PeripheralDelegate {
    
    enum BluetoothState {
        case central
        case peripheral
    }
    
    enum ConnectionState {
        case connected
        case connecting
        case disconnected
    }
    
    static let sharedInstance = BluetoothController ()
    
    let EMPTY_NAME = "empty"
    let peripheral: BTLEPeripheralModel = BTLEPeripheralModel()
    let central: BTLECentralModel = BTLECentralModel()
    let discoverTimeout: Double = 5.0 // seconds
    var state: BluetoothState
    let enemyPlayerProfile: EnemyProfile
    var isConnecting: Bool = false
    var connectionState = ConnectionState.disconnected
    
    init (){
        enemyPlayerProfile = EnemyProfile(name: EMPTY_NAME, score: 0, uuid: "")
        enemyPlayerProfile.setItems(items: Array<Item>());
        state = BluetoothState.peripheral
        setPassive()
        central.delegate = self
    }
 
    func discoverEnemies (){
        guard !isConnecting else {
            return}
        print("central active")
        //Timer.scheduledTimer(timeInterval: discoverTimeout, target: self, selector: #selector(setPassive), userInfo: nil, repeats: true)
        state = BluetoothState.central
        central.discoverPlayers()
        peripheral.setInactive()
    }
    
    @objc func setPassive (){
        guard !isConnecting else {
            return}
        
        print("central inactive")
        state = BluetoothState.peripheral
        central.setInactive()
        peripheral.setActive()
    }
    
    func connectToPlayer (player: EnemyProfile) {
        /*if state != BluetoothState.central {
            discoverEnemies()
        }*/
        isConnecting = true
        print("connect to player " + player.name)
        central.connectToPeripheral(uuid: player.uuid)
    }
    
    func checkForEnemyProfileCompleted () {
    
        if (enemyPlayerProfile.name != EMPTY_NAME
            && !enemyPlayerProfile.items.isEmpty
            && enemyPlayerProfile.score != -1) {
            onEnemyProfileCompleted()
        }
    }
    
    func onEnemyProfileCompleted () {
        // TODO show enemy profile
    }
    
    // delegate functions
    func didRetrievePlayerInfo(name: String, score: Int, uuid: String) {
        let enemy = EnemyProfile (name: name)
        enemy.setScore(score: score);
        enemy.uuid = uuid
        //checkForEnemyProfileCompleted()
        
        if AppModel.sharedInstance.enemiesList.contains(enemy){
            print("update enemy info for " + name)
            AppModel.sharedInstance.updateEnemyInfo(name: name, score: score, uuid: uuid)
        }
        else {
            AppModel.sharedInstance.addEnemyToList(enemy: enemy)
        }
    }
    
    func didRetrievePlayerInfo(items: Array<Item>, uuid: String) {
        print("didRetrievePlayerInfo")
        enemyPlayerProfile.setItems(items: items);
        //checkForEnemyProfileCompleted();
        //AppModel.sharedInstance.updateEnemyItemsInList(items: items, uuid: uuid)
    }
    
    func didDiscoverWriteAttackCharacteristic(characteristic: CBCharacteristic) {
        central.writeAttack = characteristic
    }
    
    func didDiscoverWriteScroreCharacteristic(characteristic: CBCharacteristic) {
        central.writeScore = characteristic
    }
    
    func onConnectionEstablished(uuid: String) {
        enemyPlayerProfile.uuid = uuid
    }
    
    func onConnectionAborted (uuid: String) {
        enemyPlayerProfile.uuid = ""
    }
    
    // functions for sending and receiving game challenges
    func sendGameRequestToAtackedPerson(itemToBeStolen: Item) {
        NSLog("CPC itemToBeStolen: \(itemToBeStolen.id)")
        central.sendAttack(itemToBeStolen: itemToBeStolen)
        // TODO: Jonas schick das Item itemToBeStolen an den Gegner und empfange es
        // beim Gegner mit der Methode, die hier als nächstes dann kommt: receiveGameRequestFromAttacker()
    }
    
    func receiveGameRequestFromAttacker(itemToBeStolen: Item) {
        // TODO: Jonas les das Item aus sendGameRequestToAttackedPerson aus und übergib 
        // als Parameter an die hier implementierte Funktion des AppModels. Der Methodenaufruf 
        // ist auskommentiert, da es so jetzt nicht kompilieren würde. Einfachh dann den Kommentar entffernen
        
        AppModel.sharedInstance.triggerIncomingGameFromEnemy(itemToBeStolen: itemToBeStolen)
    }
    
    // functions for sending and receiving game scores
    func sendScoreToEnemy(ownScore: Double) {
        NSLog("CPC ownScore: \(ownScore)")
        if state == BluetoothState.central {
            central.sendScore(score: ownScore)
        }
        else if state == BluetoothState.peripheral {
            peripheral.setOwnScore(score: ownScore)
        }
        // TODO: Schicke ownScore an receiveScoreFromEnemy des Gegners
    }
    
    func receiveScoreFromEnemy(score: Double) {
        // TODO: Empfange Score des Gegners aus sendScoreToEnemy und übergebe es an
        // den entsprechenden Methodenaufruf des AppModels: pushScore()
        
        //AppModel.sharedInstance.pushScore(score: <#T##Double#>)
    }
    
    
    
}
