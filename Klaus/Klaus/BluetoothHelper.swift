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

class BluetoothHelper {
    
    enum BluetoothState {
        case central
        case peripheral
    }
    
    enum ConnectionState {
        case connected
        case connecting
        case disconnected
    }

    let EMPTY_NAME = "empty"
    let peripheral: BTLEPeripheralModel = BTLEPeripheralModel()
    let central: BTLECentralModel = BTLECentralModel()
    let discoverTimeout: Double = 5.0 // seconds
    var state: BluetoothState
    let enemyPlayerProfile: EnemyProfile
    var isConnecting: Bool = false
    var connectionState = ConnectionState.disconnected
    
    func discoverOtherPlayers () {
        
        central.discoverOtherPlayers() 
        changeBluetoothState(BluetoothState.central)
        // trigger new player selected
        //  connect to get name and score and color
        //  disconnect
    }
    
    func onPlayerDiscovered (name: String, score: Int, color: UIColor, uuid: String) {
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
        // add to list
    }
    
    func connectToPlayer (playerUuid uuid: String) {
        // establish connection
        // retrieve items and icon
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
