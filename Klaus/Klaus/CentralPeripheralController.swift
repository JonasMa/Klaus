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
        print("init1")
        setPassive()
        print("init2")
    }
    
    func discoverEnemies (){
        // TODO set central active/ peripheral inactive
        state = BluetoothState.central
        central.setActive()
        peripheral.setInactive()
    }
    
    func setPassive (){
        print("setPassive1")
        state = BluetoothState.peripheral
        print("setPassive2")
        central.setInactive()
        print("setPassive3")
        peripheral.setActive()
    }
}
