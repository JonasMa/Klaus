//
//  ConnectionDelegate.swift
//  Klaus
//
//  Created by Jonas Programmierer on 29.01.17.
//  Copyright © 2017 Nimm Swag. All rights reserved.
//

import Foundation

protocol BluetoothCentralDelegate {
    
    func onPlayerDiscovered (name: String, score: Int, color: UIColor, uuid: String)
    
    func connectToPlayer (playerUuid uuid: String)
}
