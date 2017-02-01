//
//  BTLECentralModel.swift
//  Klaus
//
//  Created by Jonas Programmierer on 15.01.17.
//  Copyright © 2017 Nimm Swag. All rights reserved.
// Some parts are based on
// https://github.com/0x7fffffff/Core-Bluetooth-Transfer-Demo
// which itself is a translation from
// https://developer.apple.com/library/ios/samplecode/BTLE_Transfer/Introduction/Intro.html
// like sending chunks

import CoreBluetooth
import UIKit

class BTLECentralModel: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    // peripherals which were seen later than TIMEOUT_SECONDS ago will be deleted
    private let REFRESH_TIMEOUT_SECONDS: Double = 3.0
    private let SCAN_TIMEOUT_SECONDS: Double = 5.0
    
    private var centralManager: CBCentralManager?
    private var knownPeripherals: [CBPeripheral] = []
    private var getPlayerInfo = false
    private var connectedPeripheral: CBPeripheral?
    private var discoveredPeripheral: CBPeripheral?
    private var peripheralsWaitingList: [CBPeripheral] = []
    private var peripheralLastSeen: [String:Double] = [:]
    
    private var writeScore: CBCharacteristic?
    private var writeAttack: CBCharacteristic?
    
    private var isAvailable = false
    private var isConnected = false
    private var isActive = false
    
    private var scanTimer: Timer?
    
    var delegate: BluetoothCentralDelegate?
    
    // And somewhere to store the incoming data
    private let dataPlayer = NSMutableData()
    
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
        //Timer.scheduledTimer(timeInterval: REFRESH_TIMEOUT_SECONDS, target: self, selector: #selector(self.refreshEnemyList), userInfo: nil, repeats: true)
    }
    
    /*
        PUBLIC FUNCTIONS
    */
 
    func setActive (){
        isActive = true
        if !(centralManager?.isScanning)! {
            scanTillTimeout()
        }
    }
    
    func setInactive (){
        print("CM scanning stopped")
        isActive = false
        stopScan()
        //cleanup() // TODO check if this is too much holzhammer
    }

    
    func discoverOtherPlayers () {
        getPlayerInfo = true
    }
    
    func stopDiscoveringOtherPlayers (){
        getPlayerInfo = false
        stopScan()
        cancelPeripheralConnection(peripheral: connectedPeripheral)
    }
    
    func sendScore (score value: Double) {
        print("CM send score to enemy \(value)")
        let string: String = String(value)
        if writeScore != nil {
            
            connectedPeripheral?.setNotifyValue(true, for: writeScore!) // TOCO check if necessary
            writeToPeripheral(onCharacteristic: writeScore!, toWrite: string)
        } else {
            //connectedPeripheral?.discoverCharacteristics([scoreWriteCharacteristicUUID], for: service)
            print("CM characteristic writeScore or peripheral not known :(")
        }
        
    }
    
    func sendAttack (itemToBeStolen: Item){
        let itemString: String = itemToBeStolen.toString()
        if writeAttack != nil {
            connectedPeripheral?.setNotifyValue(true, for: writeAttack!) // TOCO check if necessary
            writeToPeripheral(onCharacteristic: writeAttack!, toWrite: itemString)
        }
        else {
            print("CM characteristic writeAttack peripheral not known :(")
        }
    }
    
    
    func connectToPeripheral (uuid: String){
        getPlayerInfo = false
        for peripheral: CBPeripheral in knownPeripherals {
            if peripheral.identifier.uuidString == uuid {
                
                centralManager?.connect(peripheral, options: nil)
                print("CM connect to " + uuid)
                return
            }
        }
        print("CM no matching peripheral found for uuid " + uuid)
    }
    
    @objc func refreshEnemyList (){
        // scan
        // wait
        // check timestamps
        
        discoverOtherPlayers()
        scanTillTimeout()
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(checkKnownPeripheralsTimestamp), userInfo: nil, repeats: false)
    }
    
    @objc func checkKnownPeripheralsTimestamp () {
        let epoch: Double = Date().timeIntervalSince1970
        for (index, peripheral) in knownPeripherals.enumerated() {
            let lastSeen: Double? = peripheralLastSeen[peripheral.identifier.uuidString]
            if lastSeen != nil {
                if epoch - lastSeen! > 2.0 {
                    knownPeripherals.remove(at: index)
                    peripheralLastSeen[peripheral.identifier.uuidString] = nil
                    delegate?.onEnemyDisappear (uuid: peripheral.identifier.uuidString)
                }
            }
        }
    }
    
    func checkIfEnemyIsStillThere (uuid: String) {
        
    }
    
    /*
      PRIVATE FUNCTIONS
    */
    
    private func onPlayerInfoReceived(receivedDataString data: String, uuid: String){
        
        sendPlayerDataToView(receivedDataString: data, uuid: uuid)
        
        cancelPeripheralConnection(peripheral: connectedPeripheral)
        
        discoverOtherPlayers()
    }
    
    private func sendPlayerDataToView (receivedDataString data: String, uuid: String){
        
        let playerInfo: [String] = data.components(separatedBy: SEPARATOR_NAME_SCORE_ITEMS)
        
        guard playerInfo.count > 3 else {
            print("CM playerInfo is too short")
            return
        }
        
        guard let scoreInt = Int(playerInfo[DATA_INDEX_SCORE]) else {
            print("CM no valid color received")
            return
        }
        print("Color String for Player \(playerInfo[DATA_INDEX_NAME]) is \(playerInfo[DATA_INDEX_COLOR])")
        // there were some problems with the extracted hex string
        let colorStrings = matches(for: "#(?:[0-9a-fA-F]){6}", in: playerInfo[DATA_INDEX_COLOR])
        let validString = colorStrings.count != 0 ? colorStrings[0] : "#000000"
        let colorUI = UIColor(hexString: validString)
        
        print("CM player details discovered. name: \(playerInfo[DATA_INDEX_NAME]), score: \(playerInfo[DATA_INDEX_SCORE])")
        
        delegate?.onPlayerDiscovered (name: playerInfo[DATA_INDEX_NAME], score: scoreInt, color: colorUI, avatar: playerInfo[DATA_INDEX_AVATAR], uuid: uuid)
    }
    
    private func matches(for regex: String, in text: String) -> [String] {
        
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let nsString = text as NSString
            let results = regex.matches(in: text, range: NSRange(location: 0, length: nsString.length))
            return results.map { nsString.substring(with: $0.range)}
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return ["#000000"]
        }
    }
    
    @objc func stopScan() {
        if (centralManager?.isScanning)! {
            centralManager?.stopScan()
        }
    }
    
    private func onItemsAndAvatarReceived(dataString: String, uuid: String) {
        let itemStrings: [String] = dataString.components(separatedBy: Item.ITEM_SEPARATOR)
        
        var items: [Item] = []
        
        for itemString in itemStrings {
            let item = Item.decode(toDecode: itemString)
            if item != nil {
                items.append(item!)
            }
            else {print("CM item decoding not successful")}
        }
        // Indexoutofrange
        delegate?.onItemsReceived(items: items, uuid: uuid)
    }
    
    
    private func writeToPeripheral (onCharacteristic char: CBCharacteristic, toWrite value: String) {
        
        let sendData: Data = value.data(using: String.Encoding.utf8)!
        connectedPeripheral?.writeValue(sendData, for: char, type: CBCharacteristicWriteType.withResponse)
    }
    
    /** Scan for peripherals - specifically for our service's 128bit CBUUID
     */
    private func scanTillTimeout() {
        print("CM scan(). isAvailable: " + String(isAvailable))
        guard isAvailable else { return }
        
        centralManager?.scanForPeripherals(
            withServices: [playerServiceUUID], options: [
                CBCentralManagerScanOptionAllowDuplicatesKey : NSNumber(value: true as Bool)
            ]
        )
        print("CM Scanning started")
        
        if scanTimer != nil {
            scanTimer!.invalidate()
        }
        scanTimer = Timer.scheduledTimer(timeInterval: SCAN_TIMEOUT_SECONDS, target: self, selector: #selector(stopScan), userInfo: nil, repeats: false)
    }

    
    private func onEomReceived(fromPeripheralUUIDString puuid: String, fromCharacteristicUUID uuid: CBUUID, dataString data: String) {
        switch uuid {
        case playerCharacteristicUUID:
            onPlayerInfoReceived(receivedDataString: data, uuid: puuid)
            break
        case scoreReadCharacteristicUUID:
            let score = Double(data)
            if score != nil {
                delegate?.onReceiveScoreFromEnemy(score: score!)
            }
            break
        case itemsCharacteristicUUID:
            onItemsAndAvatarReceived(dataString: data, uuid: puuid)
            break
        case feedbackCharacteristicUUID:
            guard let feedbackCode = Int(data) else {
                print("CM feedback not decodable: \(data)")
                break
            }
            print("feedback received: \(data)")
            delegate?.onAttackFeedback(feedbackCode: feedbackCode)
            break
        default:
            break
        }
    }
    
    
    private func cancelPeripheralConnection(peripheral: CBPeripheral?) {
        // If we've got this far, we're connected, but we're not subscribed, so we just disconnect
        if peripheral != nil {
            centralManager?.cancelPeripheralConnection(peripheral!)
        }
        connectedPeripheral = nil
        scanTillTimeout()
    }
    
    
    /** Call this when things either go wrong, or you're done with the connection.
     *  This cancels any subscriptions if there are any, or straight disconnects if not.
     *  (didUpdateNotificationStateForCharacteristic will cancel the connection if a subscription is involved)
     */
    private func cleanup() {
        isConnected = false
        // Don't do anything if we're not connected
        // self.discoveredPeripheral.isConnected is deprecated
        guard discoveredPeripheral?.state == .connected else {
            return
        }
        
        // See if we are subscribed to a characteristic on the peripheral
        guard let services = discoveredPeripheral?.services else {
            cancelPeripheralConnection(peripheral: discoveredPeripheral!)
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
    

    
    /*
        DELEGATE FUNCTIONS
     */
    
    /** centralManagerDidUpdateState is a required protocol method.
     *  Usually, you'd check for other states to make sure the current device supports LE, is powered on, etc.
     *  In this instance, we're just using it to wait for CBCentralManagerStatePoweredOn, which indicates
     *  the Central is ready to be used.
     */
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print("CM \(#line) \(#function)")
        
        if central.state == .poweredOn {
            isAvailable = true
        }
        else {
            isAvailable = false
        }
        print("CM centralManager isAvailable: " + String(isAvailable))
        // The state must be CBCentralManagerStatePoweredOn...
        // ... so start scanning
        //scan()
    }
    

    /** This callback comes whenever a peripheral that is advertising the PLAYER_SERVICE_UUID is discovered.
     */
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        //print("CM advertisement received - \(peripheral.identifier.uuidString) - \(Date())")
        peripheralLastSeen[peripheral.identifier.uuidString] = Date().timeIntervalSince1970
        
        // Ok, it's in range - have we already seen it?
        if !knownPeripherals.contains(peripheral){
            
            print("CM Discovered new \(peripheral.name)")
            
            knownPeripherals.append(peripheral)
            // Save a local copy of the peripheral, so CoreBluetooth doesn't get rid of it
            discoveredPeripheral = peripheral
            
            if getPlayerInfo {
                if isConnected {
                    // already connected to another peripheral, so wait for disconnect
                    peripheralsWaitingList.append(peripheral)
                }
                else {
                    centralManager?.connect(peripheral, options: nil)
                }
            }
        }
    }
    
    /** If the connection fails for whatever reason, we need to deal with it.
     */
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("CM Failed to connect to \(peripheral). (\(error!.localizedDescription))")
        discoveredPeripheral = nil
        isConnected = false
        //cleanup()
    }
    
    /** We've connected to the peripheral, now we need to discover the services and characteristics to find the different characteristics
     */
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("CM Peripheral Connected (\(peripheral.identifier.uuidString))")
        connectedPeripheral = peripheral
        
        isConnected = true
        //delegate?.onConnectionEstablished(uuid: peripheral.identifier.uuidString)
        // Stop scanning
        if centralManager!.isScanning {
            centralManager?.stopScan()
            print("CM Scanning stopped")
        }
        
        delegate?.onConnected()
        
        
        // Make sure we get the discovery callbacks
        peripheral.delegate = self
        
        // Search only for services that match our UUID
        peripheral.discoverServices([playerServiceUUID])
    }
    
    /** The Service was discovered
     */
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard error == nil else {
            print("CM Error discovering services: \(error!.localizedDescription)")
            cleanup()
            return
        }
        
        guard let services = peripheral.services else {
            return
        }
        
        // Discover the characteristic we want...
        
        // Loop through the newly filled peripheral.services array, just in case there's more than one.
        discoveredPeripheral = peripheral
        
        for service in services {
            if getPlayerInfo {
                dataPlayer.length = 0
                peripheral.discoverCharacteristics([playerCharacteristicUUID], for: service)
            }
            else {
                peripheral.discoverCharacteristics([scoreWriteCharacteristicUUID,scoreReadCharacteristicUUID, attackCharacteristicUUID, itemsCharacteristicUUID, feedbackCharacteristicUUID], for: service)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        if error == nil {
            print("CM write on peripheral successful")
        }
        else {
            print("CM write on peripheral NOT successful: \(error.debugDescription)")
        }
    }
    
    
    /** A characteristic was discovered.
     *  Once this has been found, we want to subscribe to it, which lets the peripheral know we want the data it contains
     */
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        // Deal with errors (if any)
        guard error == nil else {
            print("CM Error discovering services: \(error!.localizedDescription)")
            cleanup()
            return
        }
        
        
        guard let characteristics = service.characteristics else {
            return
        }
        
        // Again, we loop through the array, just in case.
        for characteristic in characteristics {
            // And check if it's the right one
            switch characteristic.uuid {
            case scoreReadCharacteristicUUID:
                print("CM found scoreCharacteristic")
                break
            case itemsCharacteristicUUID:
                print("CM found itemsCharacteristic")
                break
            case playerCharacteristicUUID:
                print("CM found playerCharacteristic")
                break
            case scoreWriteCharacteristicUUID:
                print("CM found scoreWriteCharacteristic")
                writeScore = characteristic
                //delegate?.didDiscoverWriteScroreCharacteristic(characteristic: characteristic)
                break
            case attackCharacteristicUUID:
                print("CM found writeAttackCharacteristic")
                writeAttack = characteristic
                //delegate?.didDiscoverWriteAttackCharacteristic(characteristic: characteristic)
                break
            case feedbackCharacteristicUUID:
                print("CM found feedbackCharacteristic")
                break
            default:
                print("CM found unidentified Characteristic with uuid " + characteristic.uuid.uuidString)
                
                
            }
            
            peripheral.setNotifyValue(true, for: characteristic)
            
        }
        // Once this is complete, we just need to wait for the data to come in.
    }
    
    
    /** This callback lets us know more data has arrived via notification on the characteristic
     */
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        guard error == nil else {
            print("CM Error discovering services: \(error!.localizedDescription)")
            return
        }
        
        guard let stringFromData = String(data: characteristic.value!, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue)) else {
            print("CM Invalid data")
            return
        }
        
        // Have we got everything we need?
        if stringFromData.isEqual("EOM") {
            // We have, so show the data
            guard let dataString: String = String(data: dataPlayer as Data, encoding: String.Encoding.utf8) else {
                print("CM received data doesn't stringify")
                return
            }
            print("CM Received: EOM")
            onEomReceived(fromPeripheralUUIDString:peripheral.identifier.uuidString, fromCharacteristicUUID: characteristic.uuid, dataString: dataString)
            
            peripheral.setNotifyValue(false, for: characteristic)
            dataPlayer.length = 0

            
        } else {
            // Otherwise, just add the data on to what we already have
            if characteristic.value != nil {
                dataPlayer.append(characteristic.value!)
            }
            else {
                print("CM Characteristic value is nil")
            }
            // Log it
            print("CM Received: \(stringFromData)")
        }
    }
    
    
    /** The peripheral letting us know whether our subscribe/unsubscribe happened or not
     */
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        print("CM Error changing notification state: \(error?.localizedDescription)")
        
        // Exit if it's not the transfer characteristic
        guard characteristic.uuid.isEqual(playerCharacteristicUUID) else {
            return
        }
        
        // Notification has started
        if (characteristic.isNotifying) {
            print("CM Notification began on \(characteristic)")
        } else { // Notification has stopped
            print("CM Notification stopped on (\(characteristic))  Disconnecting")
            centralManager?.cancelPeripheralConnection(peripheral)
        }
    }
    
    /** Once the disconnection happens, we need to clean up our local copy of the peripheral
     */
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("CM Peripheral Disconnected")
        discoveredPeripheral = nil
        connectedPeripheral = nil
        isConnected = false
        
        if !peripheralsWaitingList.isEmpty {
            central.connect(peripheralsWaitingList[0], options: nil)
            peripheralsWaitingList.remove(at: 0)
        }
        else {
            // check if new peripherals appeared
            //scanTillTimeout()
            refreshEnemyList()
        }
    }
   
}
