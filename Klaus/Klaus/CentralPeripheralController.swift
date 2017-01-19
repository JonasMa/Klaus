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
    
    init (){
        self.state = BluetoothState.peripheral
        central.delegate = self
        setPassive()
        enemyPlayerProfile = EnemyProfile(name: EMPTY_NAME)
        resetEnemyProfile()
    }
    
    func resetEnemyProfile(){
        enemyPlayerProfile.name = EMPTY_NAME;
        enemyPlayerProfile.items = Array<Item>()
        enemyPlayerProfile.score = -1
    }
 
    func discoverEnemies (){
        print("central active")
        Timer.scheduledTimer(timeInterval: discoverTimeout, target: self, selector: #selector(setPassive), userInfo: nil, repeats: true)
        state = BluetoothState.central
        central.setActive()
        peripheral.setInactive()
    }
    
    @objc func setPassive (){
        print("central inactive")
        state = BluetoothState.peripheral
        central.setInactive()
        peripheral.setActive()
    }
    
    func connectToPlayer (player: PlayerProfile) {
        if state != BluetoothState.central {
            discoverEnemies()
        }
        
        central.connectToPeripheral(uuid: player.name) // FIXME get right uuid
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
        enemyPlayerProfile.items = items
        checkForEnemyProfileCompleted()
    }

    func didRetrievePlayerInfo(score: Int) {
        enemyPlayerProfile.score = score
        checkForEnemyProfileCompleted()
    }
}
