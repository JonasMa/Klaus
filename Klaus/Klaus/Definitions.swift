

import CoreBluetooth


private let PLAYER_SERVICE_UUID = "E20A39F4-73F5-4BC4-AAAA-17D1AD666661"
private let PLAYER_CHARACTERISTIC_UUID = "08590F7E-DB05-467E-BBBB-72F6F66666D6"
private let ATTACK_CHARACTERISTIC_UUID = "08590F7E-DB05-467E-CCCC-72F6F66666D7"
private let SCORE_WRITE_CHARACTERISTIC_UUID = "08590F7E-DB05-467E-DDDD-72F6F66666D8"
private let SCORE_READ_CHARACTERISTIC_UUID = "08590F7E-DB05-467E-EEEE-72F6F66666D9"
private let ITEMS_CHARACTERISTIC_UUID = "08590F7E-DB05-467E-FFFF-72F6F66666DA"
private let FEEDBACK_CHARACTERISTIC_UUID = "08590F7E-DB05-467E-9999-72F6F66667DA"
let NOTIFY_MTU = 20

let playerServiceUUID = CBUUID(string: PLAYER_SERVICE_UUID)
let playerCharacteristicUUID = CBUUID(string: PLAYER_CHARACTERISTIC_UUID)
let attackCharacteristicUUID = CBUUID(string: ATTACK_CHARACTERISTIC_UUID)
let scoreReadCharacteristicUUID = CBUUID(string: SCORE_READ_CHARACTERISTIC_UUID)
let scoreWriteCharacteristicUUID = CBUUID(string: SCORE_WRITE_CHARACTERISTIC_UUID)
let itemsCharacteristicUUID = CBUUID(string: ITEMS_CHARACTERISTIC_UUID)
let feedbackCharacteristicUUID = CBUUID(string: FEEDBACK_CHARACTERISTIC_UUID)

let DEFAULT_NAME = "Unidentified Player"
let SEPARATOR_NAME_SCORE_ITEMS = "$%$"
let DATA_INDEX_NAME: Int = 0
let DATA_INDEX_SCORE: Int = 1
let DATA_INDEX_COLOR: Int = 2
let DATA_INDEX_AVATAR: Int = 3
let DATA_INDEX_ITEMS: Int = 0
let DATA_INDEX_ATTACKED_ITEM = 0
let DATA_INDEX_ATTACKER_NAME = 1

let FEEDBACK_BUSY: Int = 0000
let FEEDBACK_AVAILABLE: Int = 1111

let KEY_NAME = "name"
let KEY_SCORE = "score"
