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
    
    static let sharedInstance: BluetoothController = BluetoothController()

    private let peripheral: BTLEPeripheralModel = BTLEPeripheralModel()
    private let central: BTLECentralModel = BTLECentralModel()
    private var state: BluetoothState = BluetoothState.peripheral
    //private var checkingForAvailablePlayers: [String : Double] = [:]

    init () {
        central.delegate = self
        peripheral.delegate = self
        start()
    }
    
    func start () {
        print("BC start")
        peripheral.setActive()
        // central.setActive()
    }
    
    func stop () {
        print("BC stop")
        peripheral.setInactive()
        central.setInactive()
    }
    
    // gets triggered by system
    func setPassive(){
        changeBluetoothState(toNewState: BluetoothState.peripheral)
    }
    
    func discoverEnemies () {
        central.discoverOtherPlayers()
        changeBluetoothState(toNewState: BluetoothState.central)
    }
    
    // TODO discover avatar
    // remove avatar send and received with items
    // add avatar to player data
    func onPlayerDiscovered (name: String, score: Int, color: UIColor, avatar: String, uuid: String) {
        let enemy = EnemyProfile (name: name, score: score, uuid: uuid)
        enemy.profileColor = color
        enemy.profileAvatar = avatar
        AppModel.sharedInstance.addEnemyToList(enemy: enemy)
    }
    
    func connectToPlayer (playerUuid uuid: String) {
        changeBluetoothState(toNewState: BluetoothState.central)
        central.stopDiscoveringOtherPlayers()
        central.getItemsFromPlayer (uuid: uuid)
    }
    
    func onItemsReceived (items: [Item], uuid: String) {
        AppModel.sharedInstance.updateEnemyItemsInList(items: items, uuid: uuid)
    }
    
    func onReceiveScoreFromEnemy (score: Double) {
        NSLog("Score received bitcheez!")
        AppModel.sharedInstance.pushScore(score: score)
    }
    
    func sendGameRequestToAtackedPerson (itemToBeStolen: Item, onPlayerUuuidString uuid: String) {
        changeBluetoothState(toNewState: BluetoothState.central)
        central.sendAttack(itemToBeStolen: itemToBeStolen, fromPlayer: uuid)
    }
    
    func sendScoreToEnemy (score: Double) {
        if state == BluetoothState.central {
            central.sendScore(score: score)
        }
        else {
            peripheral.setOwnScore(score: score)
        }
    }
    
    func onGameFinish () {
        central.onGameFinish()
    }
    
    func onEnemyDisappear (uuid: String) {
        AppModel.sharedInstance.removeEnemyFromList(enemyUuid: uuid)
    }
    
    func refreshEnemyList () {
        central.refreshEnemyList()
    }
    
    func receiveGameRequestFromAttacker(itemToBeStolen: Item, attackerName name: String) {
        AppModel.sharedInstance.triggerIncomingGameFromEnemy(itemToBeStolen: itemToBeStolen, attackerName: name)
    }
    
    /*!
     Pings the player with corresponding uuid and triggers the notificationMethodName via NotificationCenter when found
     *
    func checkIfEnemyIsStillThere (uuid: String, notificationMethodName name: String) {
        checkingForAvailablePlayers[uuid] = name
    }
    
    func onEnemyIsStillThere (uuid: String){
        guard let key = checkingForAvailablePlayers[uuid] else {
            // enemy is not getting listened to
            return
        }
        NotificationCenter.default.post(name: Notification.Name(key), object: nil, userInfo: ["uuid":uuid]);
    }
    */
    func onConnected() {
        //peripheral.setInactive()
    }
    
    func onDisconnected() {
        //AppModel.sharedInstance.onGameConnectionLost()
    }
    
    func onAttackFeedback (feedbackCode: Int) {
        switch feedbackCode {
        case FEEDBACK_AVAILABLE:
            AppModel.sharedInstance.onGameStatusReceived(everythingOk: true)
            break
        case FEEDBACK_BUSY:
            AppModel.sharedInstance.onGameStatusReceived(everythingOk: false)
            break
        default:
            break
        }
    }
    
    func isPlaying () -> Bool {
        return AppModel.sharedInstance.isGaming()
    }

    private func changeBluetoothState (toNewState state: BluetoothState){
        
        if self.state == state {return}
        self.state = state
        
        if state == BluetoothState.central {
            central.setActive()
            //peripheral.setInactive()
        } else {
            //peripheral.setActive()
            central.setInactive()
        }
    }
}
