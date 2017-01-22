//
//  Definitions.swift
//  Bluetooth
//
//  Created by Mick on 12/20/14.
//  Copyright (c) 2014 MacCDevTeam LLC. All rights reserved.
//

import CoreBluetooth

let PLAYER_SERVICE_UUID = "E20A39F4-73F5-4BC4-AAAA-17D1AD666661"
let NAME_CHARACTERISTIC_UUID = "08590F7E-DB05-467E-AAAA-72F6F66666D4"
let SCORE_CHARACTERISTIC_UUID = "08590F7E-DB05-467E-AAAA-72F6F66666D5"
let ITEMS_CHARACTERISTIC_UUID = "08590F7E-DB05-467E-AAAA-72F6F66666D6"
let PLAYER_CHARACTERISTIC_UUID = "08590F7E-DB05-467E-AAAA-72F6F66666D6" // only if single characteristic is taken
let NOTIFY_MTU = 20

let playerServiceUUID = CBUUID(string: PLAYER_SERVICE_UUID)
let nameCharacteristicUUID = CBUUID(string: NAME_CHARACTERISTIC_UUID)
let scoreCharacteristicUUID = CBUUID(string: SCORE_CHARACTERISTIC_UUID)
let itemsCharacteristicUUID = CBUUID(string: ITEMS_CHARACTERISTIC_UUID)
let playerCharacteristicUUID = CBUUID(string: ITEMS_CHARACTERISTIC_UUID) // only if single chrarcteristic

let DEFAULT_NAME = "Unidentified Player"
