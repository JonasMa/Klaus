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
    
    var state: BluetoothState = BluetoothState.peripheral
    
    init (){
        
    }
}
