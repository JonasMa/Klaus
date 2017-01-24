//
//  CentralPeripheralController.swift
//  Klaus
//
//  Created by Jonas Programmierer on 15.01.17.
//  Copyright © 2017 Nimm Swag. All rights reserved.
//

import Foundation

class CentralPeripheralController: ConnectingDelegate {
    
    enum BluetoothState {
        case central
        case peripheral
    }
    
    static let sharedInstance = CentralPeripheralController ()
    
    let EMPTY_NAME = "empty"
    let peripheral: BTLEPeripheralModel = BTLEPeripheralModel()
    let central: BTLECentralModel = BTLECentralModel()
    let discoverTimeout: Double = 5.0 // seconds
    var state: BluetoothState
    let enemyPlayerProfile: EnemyProfile
    var isConnecting: Bool = false
    
    init (){
        enemyPlayerProfile = EnemyProfile(name: EMPTY_NAME, uuid: "")
        state = BluetoothState.peripheral
        setPassive()
        resetEnemyProfile()
        central.delegate = self
    }
    
    func resetEnemyProfile(){
        enemyPlayerProfile.name = EMPTY_NAME;
        enemyPlayerProfile.setItems(items: Array<Item>());
        enemyPlayerProfile.score = -1
        enemyPlayerProfile.uuid = ""
    }
 
    func discoverEnemies (){
        guard !isConnecting else {
            return}
        print("central active")
        Timer.scheduledTimer(timeInterval: discoverTimeout, target: self, selector: #selector(setPassive), userInfo: nil, repeats: true)
        state = BluetoothState.central
        central.setActive()
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
    func didRetrievePlayerInfo(name: String) {
        enemyPlayerProfile.name = name
        checkForEnemyProfileCompleted()
    }
    
    func didRetrievePlayerInfo(items: Array<Item>) {
        enemyPlayerProfile.setItems(items: items);
        checkForEnemyProfileCompleted();
    }

    func didRetrievePlayerInfo(score: Int) {
        enemyPlayerProfile.setScore(score: score);
        checkForEnemyProfileCompleted()
    }
    
    // functions for sending and receiving game challenges
    func sendGameRequestToAtackedPerson(itemToBeStolen: Item) {
        // TODO: Jonas schick das Item itemToBeStolen an den Gegner und empfange es
        // beim Gegner mit der Methode, die hier als nächstes dann kommt: receiveGameRequestFromAttacker()
    }
    
    func receiveGameRequestFromAttacker() {
        // TODO: Jonas les das Item aus sendGameRequestToAttackedPerson aus und übergib 
        // als Parameter an die hier implementierte Funktion des AppModels
        
        AppModel.sharedInstance.triggerIncomingGameFromEnemy(itemToBeStolen: <#T##Item#>)
    }
}
