//
//  BTLECentralModel.swift
//  Klaus
//
//  Created by Jonas Programmierer on 15.01.17.
//  Copyright © 2017 Nimm Swag. All rights reserved.
//
// In structure it is based on
// https://github.com/0x7fffffff/Core-Bluetooth-Transfer-Demo
// which itself is a translation from
// https://developer.apple.com/library/ios/samplecode/BTLE_Transfer/Introduction/Intro.html

import CoreBluetooth


class BTLECentralModel: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    fileprivate var centralManager: CBCentralManager?
    fileprivate var discoveredPeripheral: CBPeripheral?
    fileprivate var discoveredServices: [CBService]?
    
    private var connectedPeripheral: CBPeripheral?
    
    var delegate: CentralDelegate?
    var writeScore: CBCharacteristic?
    var writeAttack: CBCharacteristic?
    
    var isAvailable: Bool = false
    var isActive: Bool = false
    
    // handling player data interaction
    var knownPeripherals: [CBPeripheral] = []
    var peripheralIterator: Int = 0
    var getPlayerInfo: Bool = false
    
    var isConnected: Bool = false
    
    // And somewhere to store the incoming data
    private let dataPlayer = NSMutableData()
    
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }

    func discoverPlayers () {
        getPlayerInfo = true
        setActive()
    }
    
    func getNextPlayer (){
        if getPlayerInfo {
            discoverPlayers()
        }
    }
    
    func onPlayerInfoReceived (name: String, score: Int, uuid: String){
        AppModel.sharedInstance.updateEnemyInfo(name: name, score: score, uuid: uuid)
        getNextPlayer()
    }
    
    func setActive (){
        isActive = true
        scan() //TODO check if this has to be be invoked every time
    }
    
    func setInactive (){
        isActive = false
        stopScan()
        cleanup() // TODO check if this is too much holzhammer
    }
    
    func stopScan() {
        if (centralManager?.isScanning)! {
            centralManager?.stopScan()
        }
    }
    
    func peripheralDidUpdateName(_ peripheral: CBPeripheral) {
        if knownPeripherals.contains(peripheral) {
            // TODO update name of peripheral
            //peripheral.
        }
    }
    
    func sendScore (score value: Double) {
        let string: String = String(value)
        if writeScore != nil {
            writeToPeripheral(onCharacteristic: writeScore!, toWrite: string)
        } else {
            print("characteristic writeScore or peripheral not known :(")
        }

    }
    
    func sendAttack (itemToBeStolen: Item){
        let itemString: String = itemToBeStolen.toString()
        if writeAttack != nil {
            writeToPeripheral(onCharacteristic: writeAttack!, toWrite: itemString)
        }
        else {
            print("characteristic writeAttack peripheral not known :(")
        }
    }
    

    private func writeToPeripheral (onCharacteristic char: CBCharacteristic, toWrite value: String) {

        let sendData: Data = value.data(using: String.Encoding.utf8)!
        connectedPeripheral?.writeValue(sendData, for: char, type: CBCharacteristicWriteType.withResponse)
    }
    
    func enemyDiscovered (name: String?, uuid: String) {
        var enemyName: String
        if name != nil {
            enemyName = name!
        }
        else {
            enemyName = DEFAULT_NAME
        }
        let profile = EnemyProfile(name: enemyName, score: 0, uuid: uuid)
        print("Enemy seen!! ")
        AppModel.sharedInstance.addEnemyToList(enemy: profile)
    }
    
    /** centralManagerDidUpdateState is a required protocol method.
     *  Usually, you'd check for other states to make sure the current device supports LE, is powered on, etc.
     *  In this instance, we're just using it to wait for CBCentralManagerStatePoweredOn, which indicates
     *  the Central is ready to be used.
     */
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print("\(#line) \(#function)")

        if central.state == .poweredOn {
            isAvailable = true
        }
        else {
            isAvailable = false
        }
        print("centralManager isAvailable: " + String(isAvailable))
        // The state must be CBCentralManagerStatePoweredOn...
        // ... so start scanning
        //scan()
    }
    
    /** Scan for peripherals - specifically for our service's 128bit CBUUID
     */
    func scan() {
        print("scan(). isAvailable: " + String(isAvailable))
        guard isAvailable else { return }
        
        centralManager?.scanForPeripherals(
            withServices: [playerServiceUUID], options: [
                CBCentralManagerScanOptionAllowDuplicatesKey : NSNumber(value: true as Bool)
            ]
        )
        
        print("Scanning started")
    }
    
    
    func connectToPeripheral (uuid: String){
        getPlayerInfo = false
        print("connect to " + uuid)
        for peripheral: CBPeripheral in knownPeripherals {
            if peripheral.identifier.uuidString == uuid {
                centralManager?.connect(peripheral, options: nil)
                return
            }
        }
        print("no matching peripheral found for uuid " + uuid)
    }
    
    /** This callback comes whenever a peripheral that is advertising the PLAYER_SERVICE_UUID is discovered.
     */
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        // Reject any where the value is above reasonable range
        // Reject if the signal strength is too low to be close enough (Close is around -22dB)
        
        //        if  RSSI.integerValue < -15 && RSSI.integerValue > -35 {
        //            println("Device not at correct range")
        //            return
        //        }

        // Ok, it's in range - have we already seen it?
        if !knownPeripherals.contains(peripheral){
        //if discoveredPeripheral != peripheral {
            
            print("Discovered new \(peripheral.name)")
            
            knownPeripherals.append(peripheral)
            // Save a local copy of the peripheral, so CoreBluetooth doesn't get rid of it
            discoveredPeripheral = peripheral
            
            // And connect
            //print("Connecting to peripheral \(peripheral)")
     
            if getPlayerInfo {
                centralManager?.connect(peripheral, options: nil)
            }

            enemyDiscovered(name: peripheral.name, uuid: peripheral.identifier.uuidString)
            // TODO check if this is obsolete when we connect directly
        }
    }
    
    /** If the connection fails for whatever reason, we need to deal with it.
     */
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("Failed to connect to \(peripheral). (\(error!.localizedDescription))")
        discoveredPeripheral = nil
        cleanup()
    }
    
    /** We've connected to the peripheral, now we need to discover the services and characteristics to find the different characteristics
     */
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Peripheral Connected")
        connectedPeripheral = peripheral
        
        isConnected = true
        delegate?.onConnectionEstablished(uuid: peripheral.identifier.uuidString)
        // Stop scanning
        if centralManager!.isScanning {
            centralManager?.stopScan()
            print("Scanning stopped")
        }

        
        // Make sure we get the discovery callbacks
        peripheral.delegate = self
        
        // Search only for services that match our UUID
        peripheral.discoverServices([playerServiceUUID])
    }
    
    /** The Service was discovered
     */
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard error == nil else {
            print("Error discovering services: \(error!.localizedDescription)")
            cleanup()
            return
        }
        
        guard let services = peripheral.services else {
            return
        }
        
        // Discover the characteristic we want...
        
        // Loop through the newly filled peripheral.services array, just in case there's more than one.
        discoveredServices = services
        
        for service in services {
            if getPlayerInfo {
                dataPlayer.length = 0
                peripheral.discoverCharacteristics([playerCharacteristicUUID], for: service)
            }
            else {
                peripheral.discoverCharacteristics([scoreWriteCharacteristicUUID], for: service)
                peripheral.discoverCharacteristics([scoreReadCharacteristicUUID], for: service)
                peripheral.discoverCharacteristics([attackCharacteristicUUID], for: service)
                peripheral.discoverCharacteristics([itemsCharacteristicUUID], for: service)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        if error == nil {
            print("write on peripheral successful")
        }
        else {
            print("write on peripheral NOT successful")
        }
    }
    
    
    /** A characteristic was discovered.
     *  Once this has been found, we want to subscribe to it, which lets the peripheral know we want the data it contains
     */
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        // Deal with errors (if any)
        guard error == nil else {
            print("Error discovering services: \(error!.localizedDescription)")
            cleanup()
            return
        }
        
        
        guard let characteristics = service.characteristics else {
            return
        }
        
        // Again, we loop through the array, just in case.
        for characteristic in characteristics {
            // And check if it's the right one
            if characteristic.uuid.isEqual(scoreReadCharacteristicUUID)
                || characteristic.uuid.isEqual(itemsCharacteristicUUID){
                if characteristic.uuid.isEqual(itemsCharacteristicUUID) {
                    print("CM found itemsCharacteristic")
                } else {
                    print("CM found scoreCharacteristic")
                }
                
                // If it is, subscribe to it
                peripheral.setNotifyValue(true, for: characteristic)
            }
            else if characteristic.uuid.isEqual(playerCharacteristicUUID) {
                print("CM found playerCharacteristic")
                let playerInfo: [String] = String(data: characteristic.value!, encoding: String.Encoding.utf8)!.components(separatedBy: SEPARATOR_NAME_SCORE_ITEMS)
                
                if playerInfo.count > 1 {
                    let score: Int? = Int(playerInfo[DATA_INDEX_SCORE])
                    if score != nil {
                        onPlayerInfoReceived(name: playerInfo[DATA_INDEX_NAME], score: score!, uuid: peripheral.identifier.uuidString)
                        print("player details discovered. name: \(playerInfo[DATA_INDEX_NAME]), score: \(score)")
                    }
                    else { print("score could not be unwrapped") }
                } else { print("playerInfo could not be splitted") }
                
            }
            else if characteristic.uuid.isEqual(scoreWriteCharacteristicUUID){
                print("CM found scoreWriteCharacteristic")
                delegate?.didDiscoverWriteScroreCharacteristic(characteristic: characteristic)
            }
            else if characteristic.uuid.isEqual(attackCharacteristicUUID){
                print("CM found writeAttackCharacteristic")
                delegate?.didDiscoverWriteAttackCharacteristic(characteristic: characteristic)
            }
            
            
 
        }
        // Once this is complete, we just need to wait for the data to come in.
    }
    
    func handleAndDecodePlayerItems (uuid: String) {
        let dataString = String (data: dataPlayer as Data, encoding: String.Encoding.utf8)
        let itemStrings = dataString!.components(separatedBy: Item.ITEM_SEPARATOR)
        var array: Array<Item> = Array<Item>()
        for itemString in itemStrings {
            let decoded: Item? = Item.decode(toDecode: itemString)
            
            if decoded != nil {
                array.append(decoded!)
            }
            else {
                print("Item not decodable")
            }
        }
        delegate?.didRetrievePlayerInfo(items: array, uuid: uuid)
    }
    /*
    func handleAndDecodePlayerData (dataString: String) -> EnemyProfile {
        let dataString = String(data: dataPlayer.copy() as! Data, encoding: String.Encoding.utf8)!
        let splittedDataString = dataString.components(separatedBy: SEPARATOR_NAME_SCORE_ITEMS)
        
        let name: String = splittedDataString[DATA_INDEX_NAME]
        
    
        let score: Int = Int(splittedDataString[DATA_INDEX_SCORE])!
        
        //delegate?.didRetrievePlayerInfo(name: name)
        delegate?.didRetrievePlayerInfo(score: score)
        //delegate?.didRetrievePlayerInfo(items: array)
        
    }
    */
    
    /** This callback lets us know more data has arrived via notification on the characteristic
     */
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        guard error == nil else {
            print("Error discovering services: \(error!.localizedDescription)")
            return
        }
        
        
        
        guard let stringFromData = NSString(data: characteristic.value!, encoding: String.Encoding.utf8.rawValue) else {
            print("Invalid data")
            return
        }
        
        // Have we got everything we need?
        if stringFromData.isEqual(to: "EOM") {
            // We have, so show the data
            
            
            switch characteristic.uuid {
            case playerCharacteristicUUID:
                print("EOM from player characteristic received")
                // this happens in discovery of characteristic
                // onPlayerInfoReceived(name: playerInfo[DATA_INDEX_NAME], score: score!, uuid: peripheral.identifier.uuidString)
                // peripheral?.didRetrievePlayerInfo(name: String, score: Int, uuid: String)
                break
            case scoreReadCharacteristicUUID:
                let dataString = String (data: dataPlayer as Data, encoding: String.Encoding.utf8)
                let score = Double(dataString!)
                if score != nil {
                    delegate?.receiveScoreFromEnemy(score: score!)
                }
                break
            case itemsCharacteristicUUID:
                handleAndDecodePlayerItems(uuid: peripheral.identifier.uuidString )
                break
            default:
                break
            }
            
            
            
            peripheral.setNotifyValue(false, for: characteristic)
            
            
            // TODO find out when to cancel connection
            
            
            // and disconnect from the peripehral
            //centralManager?.cancelPeripheralConnection(peripheral)
            
        } else {
            // Otherwise, just add the data on to what we already have
            if characteristic.value != nil {
                dataPlayer.append(characteristic.value!)
            }
            else {
                print("Characteristic value is nil")
            }
            // Log it
            print("Received: \(stringFromData)")
        }
    }

    
    /** The peripheral letting us know whether our subscribe/unsubscribe happened or not
     */
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        print("Error changing notification state: \(error?.localizedDescription)")
        
        // Exit if it's not the transfer characteristic
        guard characteristic.uuid.isEqual(playerCharacteristicUUID) else {
            return
        }
        
        // Notification has started
        if (characteristic.isNotifying) {
            print("Notification began on \(characteristic)")
        } else { // Notification has stopped
            print("Notification stopped on (\(characteristic))  Disconnecting")
            centralManager?.cancelPeripheralConnection(peripheral)
        }
    }
    
    /** Once the disconnection happens, we need to clean up our local copy of the peripheral
     */
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("Peripheral Disconnected")
        discoveredPeripheral = nil
        isConnected = false
        
        // We're disconnected, so start scanning again
        // scan()
    }
    
    
    /** Call this when things either go wrong, or you're done with the connection.
     *  This cancels any subscriptions if there are any, or straight disconnects if not.
     *  (didUpdateNotificationStateForCharacteristic will cancel the connection if a subscription is involved)
     */
    fileprivate func cleanup() {
        isConnected = false
        // Don't do anything if we're not connected
        // self.discoveredPeripheral.isConnected is deprecated
        guard discoveredPeripheral?.state == .connected else {
            return
        }
        
        // See if we are subscribed to a characteristic on the peripheral
        guard let services = discoveredPeripheral?.services else {
            cancelPeripheralConnection()
            return
        }
        
        for service in services {
            guard let characteristics = service.characteristics else {
                continue
            }
            
            for characteristic in characteristics {
                //if (characteristic.uuid.isEqual(playerCharacteristicUUID)
                    if characteristic.isNotifying {
                        discoveredPeripheral?.setNotifyValue(false, for: characteristic)
                    // And we're done.
                    //return
                }
            }
        }
    }
    
    fileprivate func cancelPeripheralConnection() {
        // If we've got this far, we're connected, but we're not subscribed, so we just disconnect
        centralManager?.cancelPeripheralConnection(discoveredPeripheral!)
    }

}
