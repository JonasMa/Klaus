//
//  ConnectingDelegate.swift
//  Klaus
//
//  Created by Jonas Programmierer on 19.01.17.
//  Copyright © 2017 Nimm Swag. All rights reserved.
//

import Foundation
import CoreBluetooth


protocol ConnectingDelegate {
    
    func didRetrievePlayerInfo(name: String, score: Int, uuid: String)
    
    func didRetrievePlayerInfo(items: Array<Item>, uuid: String)
    
    func didDiscoverWriteScroreCharacteristic (characteristic: CBCharacteristic)
    
    func didDiscoverWriteAttackCharacteristic (characteristic: CBCharacteristic)
}
