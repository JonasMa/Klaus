//
//  BluetoothHelper.swift
//  Klaus
//
//  Created by Jonas Programmierer on 29.01.17.
//  Copyright © 2017 Nimm Swag. All rights reserved.
//

import Foundation
import CoreBluetooth
import UIKit

class BluetoothController: BluetoothCentralDelegate, BluetoothPeripheralDelegate {
    
    enum BluetoothState {
        case central
        case peripheral
    }
    
    enum ConnectionState {
        case connected
        case connecting
        case disconnected
    }
    
    static let sharedInstance: BluetoothController = BluetoothController()

    let peripheral: BTLEPeripheralModel = BTLEPeripheralModel()
    let central: BTLECentralModel = BTLECentralModel()
    var state: BluetoothState = BluetoothState.peripheral
    //let enemyPlayerProfile: EnemyProfile
    //var isConnecting: Bool = false
    //var connectionState = ConnectionState.disconnected

    init () {
        central.delegate = self
        peripheral.delegate = self
        setPassive()
    }
    // gets triggered by system
    func setPassive(){
        changeBluetoothState(toNewState: BluetoothState.peripheral)
    }
    
    func discoverEnemies () {
        
        central.discoverOtherPlayers()
        changeBluetoothState(toNewState: BluetoothState.central)
    }
    
    func onPlayerDiscovered (name: String, score: Int, color: UIColor, uuid: String) {
        let enemy = EnemyProfile (name: name, score: score, uuid: uuid)
        enemy.profileColor = color
        AppModel.sharedInstance.addEnemyToList(enemy: enemy)
    }
    
    func connectToPlayer (playerUuid uuid: String) {
        central.stopDiscoveringOtherPlayers()
        central.connectToPeripheral(uuid: uuid)
    }
    
    func onItemsAndAvatarReceived (items: [Item], avatar: String, uuid: String) {
        AppModel.sharedInstance.updateEnemyItemsInList(items: items, avatar:avatar, uuid: uuid)
    }
    
    func onReceiveScoreFromEnemy (score: Double) {
        NSLog("Score received bitcheez!")
        AppModel.sharedInstance.pushScore(score: score)
    }
    
    func sendGameRequestToAtackedPerson (itemToBeStolen: Item) {
        central.sendAttack(itemToBeStolen: itemToBeStolen)
    }
    
    func sendScoreToEnemy (score: Double) {
        central.sendScore(score: score)
    }
    
    func onEnemyDisappear (uuid: String) {
        AppModel.sharedInstance.removeEnemyFromList(enemyUuid: uuid)
    }
    
    func refreshEnemyList () {
        central.refreshEnemyList()
    }
    
    func receiveGameRequestFromAttacker(itemToBeStolen: Item) {
        AppModel.sharedInstance.triggerIncomingGameFromEnemy(itemToBeStolen: itemToBeStolen)
    }

    private func changeBluetoothState (toNewState state: BluetoothState){
        self.state = state
        if state == BluetoothState.central {
            central.setActive()
            peripheral.setInactive()
        } else {
            peripheral.setActive()
            central.setInactive()
        }
    }
}
