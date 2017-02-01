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
    
    private enum RequestType {
        case Name
        case Items
        case Attack
        case Unknown
    }
    
    // peripherals which were seen later than TIMEOUT_SECONDS ago will be deleted
    private let REFRESH_TIMEOUT_SECONDS: Double = 3.0
    private let SCAN_TIMEOUT_SECONDS: Double = 5.0
    
    private var centralManager: CBCentralManager?
    private var knownPeripherals: [CBPeripheral] = []
    private var connectedPeripheral: CBPeripheral?
    private var peripheralsWaitingList: [CBPeripheral] = []
    private var peripheralLastSeen: [String:Double] = [:]
    
    private var writeScore: CBCharacteristic?
    private var writeAttack: CBCharacteristic?
    
    private var isAvailable = false
    private var isActive = false
    private var itemToBeStolen: Item?
    private var requestType: RequestType = RequestType.Unknown
    
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
        requestType = RequestType.Name
    }
    
    func stopDiscoveringOtherPlayers (){
        // should not be needed anymore
        //requestType = RequestType.Unknown
        stopScan()
        cancelPeripheralConnection()
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
    
    func sendAttack (itemToBeStolen: Item, fromPlayer uuid: String){
        requestType = RequestType.Attack
        self.itemToBeStolen = itemToBeStolen
        connectToPeripheral(uuid: uuid, withIntention: RequestType.Attack)
    }
    
    func getItemsFromPlayer (uuid: String) {
        connectToPeripheral (uuid: uuid, withIntention: RequestType.Items)
    }
    
    
    @objc func refreshEnemyList (){
        requestType = RequestType.Name
        cancelPeripheralConnection()
        discoverOtherPlayers()
        scanTillTimeout()
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(checkKnownPeripheralsTimestamp), userInfo: nil, repeats: false)
    }
    
    @objc func checkKnownPeripheralsTimestamp () {
        let epoch: Double = Date().timeIntervalSince1970
        var toDelete: [CBPeripheral] = []
        for peripheral in knownPeripherals {
            let lastSeen: Double? = peripheralLastSeen[peripheral.identifier.uuidString]
            if lastSeen != nil {
                if epoch - lastSeen! > 2.0 {
                    toDelete.append(peripheral)
                }
            }
        }
        
        for peripheral in toDelete {
            if let index: Int = knownPeripherals.index(of: peripheral) {
                knownPeripherals.remove(at: index)
            }
            let uuid = peripheral.identifier.uuidString
            peripheralLastSeen[uuid] = nil
            delegate?.onEnemyDisappear (uuid: uuid)
        }
    }
    
    func onGameFinish () {
        if connectedPeripheral != nil {
            cancelPeripheralConnection()
        }
    }
    
    /*
      PRIVATE FUNCTIONS
    */
    
    private func connectToPeripheral (uuid: String, withIntention: RequestType){
        if connectedPeripheral != nil {
            print("CM cancel connecton before (re)connecting")
            cancelPeripheralConnection()
        }
        requestType = withIntention
        for peripheral: CBPeripheral in knownPeripherals {
            if peripheral.identifier.uuidString == uuid {
                
                centralManager?.connect(peripheral, options: nil)
                print("CM connect to " + uuid)
                return
            }
        }
        print("CM no matching peripheral found for uuid " + uuid)
    }
    
    private func sendPendingAttack () {
        
        guard let item = itemToBeStolen else {
            print("CM no item cached to be stolen")
            return
        }
        let itemString: String = item.toString()
        if writeAttack != nil {
            //connectedPeripheral?.setNotifyValue(true, for: writeAttack!) // TOCO check if necessary
            writeToPeripheral(onCharacteristic: writeAttack!, toWrite: itemString)
        }
        else {
            print("CM characteristic writeAttack peripheral not known :(")
        }
    }
    
    private func onPlayerInfoReceived(receivedDataString data: String, uuid: String){
        
        sendPlayerDataToView(receivedDataString: data, uuid: uuid)
        
        cancelPeripheralConnection()
        
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
        
        let colorUI = UIColor(hexString: playerInfo[DATA_INDEX_COLOR])
        
        print("CM player details discovered. name: \(playerInfo[DATA_INDEX_NAME]), score: \(playerInfo[DATA_INDEX_SCORE])")
        
        delegate?.onPlayerDiscovered (name: playerInfo[DATA_INDEX_NAME], score: scoreInt, color: colorUI, avatar: playerInfo[DATA_INDEX_AVATAR], uuid: uuid)
    }
    
    @objc func stopScan() {
        print("CM scanning stopped")
        if (centralManager?.isScanning)! {
            centralManager?.stopScan()
        }
    }
    
    private func onItemsReceived(dataString: String, uuid: String) {
        let itemStrings: [String] = dataString.components(separatedBy: Item.ITEM_SEPARATOR)
        
        var items: [Item] = []
        
        for itemString in itemStrings {
            let item = Item.decode(toDecode: itemString)
            if item != nil {
                items.append(item!)
            }
            else {print("CM item decoding not successful")}
        }
        delegate?.onItemsReceived(items: items, uuid: uuid)
        cancelPeripheralConnection()
        //cleanup()
    }
    
    
    private func writeToPeripheral (onCharacteristic char: CBCharacteristic, toWrite value: String) {
        
        let sendData: Data = value.data(using: String.Encoding.utf8)!
        connectedPeripheral?.writeValue(sendData, for: char, type: CBCharacteristicWriteType.withResponse)
    }
    
    /** Scan for peripherals - specifically for our service's 128bit CBUUID
     */
    private func scanTillTimeout() {
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
            onItemsReceived(dataString: data, uuid: puuid)
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
    
    
    private func cancelPeripheralConnection() {
        // If we've got this far, we're connected, but we're not subscribed, so we just disconnect
        if connectedPeripheral != nil {
            centralManager?.cancelPeripheralConnection(connectedPeripheral!)
            connectedPeripheral = nil
        }
        scanTillTimeout()
    }
    
    
    /** Call this when things either go wrong, or you're done with the connection.
     *  This cancels any subscriptions if there are any, or straight disconnects if not.
     *  (didUpdateNotificationStateForCharacteristic will cancel the connection if a subscription is involved)
     */
    private func cleanup() {
        // Don't do anything if we're not connected
        // self.discoveredPeripheral.isConnected is deprecated
        guard connectedPeripheral?.state == .connected else {
            return
        }
        
        // See if we are subscribed to a characteristic on the peripheral
        guard let services = connectedPeripheral?.services else {
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
                    connectedPeripheral?.setNotifyValue(false, for: characteristic)
                    // And we're done.
                    //return
                }
            }
        }
    }
    

    
    /*
        DELEGATE FUNCTIONS
     */
    
    func peripheralDidUpdateName(_ peripheral: CBPeripheral) {
        print("CM peripheralDidUpdateName. Name: \(peripheral.name), uuid: \(peripheral.identifier.uuidString)")
    }
    
    /** centralManagerDidUpdateState is a required protocol method.
     *  Usually, you'd check for other states to make sure the current device supports LE, is powered on, etc.
     *  In this instance, we're just using it to wait for CBCentralManagerStatePoweredOn, which indicates
     *  the Central is ready to be used.
     */
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print("CM \(#line) \(#function)")
        
        if central.state == .poweredOn {
            isAvailable = true
            /* probably not necessary
            if isActive
                && !(centralManager?.isScanning)!{
                scanTillTimeout()
            }
            */
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
        if !containsAndUpdate(peripheral: peripheral){
            
            print("CM Discovered new \(peripheral.name). RequestType is \(requestType)")
            // Save a local copy of the peripheral, so CoreBluetooth doesn't get rid of it
            
            if true {
            //if requestType == RequestType.Name {
                if connectedPeripheral != nil {
                    // already connected to another peripheral, so wait for disconnect
                    peripheralsWaitingList.append(peripheral)
                    print("CM set peripheral on waiting list")
                }
                else {
                    print("CM connecting to \(peripheral.name) ... (\(peripheral.identifier.uuidString))")
                    centralManager?.connect(peripheral, options: nil)
                }
            }
            connectedPeripheral = peripheral
        }
    }
    
    // check only for uuid to prevent same devices with different name
    private func containsAndUpdate (peripheral: CBPeripheral) ->Bool {
        let uuidString = peripheral.identifier.uuidString
        for (index, per) in knownPeripherals.enumerated() {
            if per.identifier.uuidString == uuidString{
                knownPeripherals[index] = peripheral
                return true
            }
        }
        knownPeripherals.append(peripheral)
        return false
    }
    
    /** If the connection fails for whatever reason, we need to deal with it.
     */
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("CM Failed to connect to \(peripheral). (\(error!.localizedDescription))")
        connectedPeripheral = nil
        //cleanup()
    }
    
    /** We've connected to the peripheral, now we need to discover the services and characteristics to find the different characteristics
     */
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("CM Peripheral Connected (\(peripheral.identifier.uuidString))")
        connectedPeripheral = peripheral
        
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
        connectedPeripheral = peripheral
        
        for service in services {
            
            dataPlayer.length = 0
            switch requestType {
            case RequestType.Name:
                peripheral.discoverCharacteristics([playerCharacteristicUUID], for: service)
                break
            case RequestType.Attack:
                peripheral.discoverCharacteristics([feedbackCharacteristicUUID, scoreWriteCharacteristicUUID, scoreReadCharacteristicUUID, attackCharacteristicUUID], for: service)
                break
            case RequestType.Items:
                peripheral.discoverCharacteristics([itemsCharacteristicUUID], for: service)
                break
            default:
                print("ERROR unknown request type on peripheral")
                break
            }
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
                break
            case attackCharacteristicUUID:
                print("CM found writeAttackCharacteristic")
                writeAttack = characteristic
                if requestType == RequestType.Attack {
                    sendPendingAttack()
                }
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
        connectedPeripheral = nil
        delegate?.onDisconnected()
        
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
