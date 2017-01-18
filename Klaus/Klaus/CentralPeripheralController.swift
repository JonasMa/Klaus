//
//  CentralPeripheralController.swift
//  Klaus
//
//  Created by Jonas Programmierer on 15.01.17.
//  Copyright © 2017 Nimm Swag. All rights reserved.
//

import Foundation

class CentralPeripheralController {
    
    enum BluetoothState {
        case central
        case peripheral
    }
    
    static let sharedInstance = CentralPeripheralController ()
    
    let peripheral: BTLEPeripheralModel = BTLEPeripheralModel()
    let central: BTLECentralModel = BTLECentralModel()
    var state: BluetoothState
    
    init (){
        self.state = BluetoothState.peripheral
        setPassive()
    }
    
    func discoverEnemies (){
        // TODO set central active/ peripheral inactive
        print("central active")
        state = BluetoothState.central
        central.setActive()
        peripheral.setInactive()
    }
    
    func setPassive (){
        state = BluetoothState.peripheral
        print("central inactive")
        central.setInactive()
        peripheral.setActive()
    }
}
