//
//  Definitions.swift
//  Bluetooth
//
//  Created by Mick on 12/20/14.
//  Copyright (c) 2014 MacCDevTeam LLC. All rights reserved.
//

import CoreBluetooth

let PLAYER_SERVICE_UUID = "E20A39F4-73F5-4BC4-AAAA-17D1AD666661"
let PLAYER_CHARACTERISTIC_UUID = "08590F7E-DB05-467E-BBBB-72F6F66666D6" // only if single characteristic is taken
let NOTIFY_MTU = 20

let playerServiceUUID = CBUUID(string: PLAYER_SERVICE_UUID)
let playerCharacteristicUUID = CBUUID(string: PLAYER_CHARACTERISTIC_UUID) // only if single chrarcteristic

let DEFAULT_NAME = "Unidentified Player"
let SEPARATOR_NAME_SCORE_ITEMS = "$%$"
let DATA_INDEX_NAME: Int = 0
let DATA_INDEX_SCORE: Int = 1
let DATA_INDEX_ITEMS: Int = 2

