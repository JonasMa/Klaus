//
//  ConnectionDelegate.swift
//  Klaus
//
//  Created by Jonas Programmierer on 29.01.17.
//  Copyright © 2017 Nimm Swag. All rights reserved.
//

import Foundation
import UIKit

protocol BluetoothCentralDelegate {
    
    func onPlayerDiscovered (name: String, score: Int, color: UIColor, avatar: String, uuid: String)
    
    func onItemsReceived (items: [Item], uuid: String)
    
    func onReceiveScoreFromEnemy (score: Double)
    
    func onEnemyDisappear (uuid: String)
    
    //func onEnemyIsStillThere (uuid: String)
    
    func onConnected ()
    
    func onDisconnected()
    
    func onAttackFeedback (feedbackCode: Int)

}

protocol BluetoothPeripheralDelegate {
    
    func receiveGameRequestFromAttacker(itemToBeStolen: Item)
    
    func onReceiveScoreFromEnemy (score: Double)
    
    func isPlaying () -> Bool
}
