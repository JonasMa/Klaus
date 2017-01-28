//
//  Definitions.swift
//  Bluetooth
//
//  Created by Mick on 12/20/14.
//  Copyright (c) 2014 MacCDevTeam LLC. All rights reserved.
//

import CoreBluetooth

// TODO: split in playeritems and playerinfo characteristic

private let PLAYER_SERVICE_UUID = "E20A39F4-73F5-4BC4-AAAA-17D1AD666661"
private let PLAYER_CHARACTERISTIC_UUID = "08590F7E-DB05-467E-BBBB-72F6F66666D6"
private let ATTACK_CHARACTERISTIC_UUID = "08590F7E-DB05-467E-CCCC-72F6F66666D6"
private let SCORE_WRITE_CHARACTERISTIC_UUID = "08590F7E-DB05-467E-DDDD-72F6F66666D6"
private let SCORE_READ_CHARACTERISTIC_UUID = "08590F7E-DB05-467E-EEEE-72F6F66666D6"
private let ITEMS_CHARACTERISTIC_UUID = "08590F7E-DB05-467E-FFFF-72F6F66666D6"
let NOTIFY_MTU = 20

let playerServiceUUID = CBUUID(string: PLAYER_SERVICE_UUID)
let playerCharacteristicUUID = CBUUID(string: PLAYER_CHARACTERISTIC_UUID)
let attackCharacteristicUUID = CBUUID(string: ATTACK_CHARACTERISTIC_UUID)
let scoreReadCharacteristicUUID = CBUUID(string: SCORE_READ_CHARACTERISTIC_UUID)
let scoreWriteCharacteristicUUID = CBUUID(string: SCORE_WRITE_CHARACTERISTIC_UUID)
let itemsCharacteristicUUID = CBUUID(string: ITEMS_CHARACTERISTIC_UUID)

let DEFAULT_NAME = "Unidentified Player"
let SEPARATOR_NAME_SCORE_ITEMS = "$%$"
let DATA_INDEX_NAME: Int = 0
let DATA_INDEX_SCORE: Int = 1
let DATA_INDEX_ITEMS: Int = 2


let KEY_NAME = "name"
let KEY_SCORE = "score"
