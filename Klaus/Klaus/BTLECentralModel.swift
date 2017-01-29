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
import UIKit

class BTLECentralModel: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    fileprivate var centralManager: CBCentralManager?
    private var knownPeripherals: [CBPeripheral] = []
    private var getPlayerInfo = false
    private var connectedPeripheral: CBPeripheral?
    private var discoveredPeripheral: CBPeripheral?
    
    private var writeScore: CBCharacteristic?
    private var writeAttack: CBCharacteristic?
    
    private var isAvailable = false
    private var isConnected = false
    
    var delegate: BluetoothCentralDelegate?
    
    // And somewhere to store the incoming data
    private let dataPlayer = NSMutableData()
    
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    func setActive (){
        scan()
    }
    
    func setInactive (){
        stopScan()
        //cleanup() // TODO check if this is too much holzhammer
    }

    
    func discoverOtherPlayers () {
        getPlayerInfo = true
        if !(centralManager?.isScanning)! {
            scan()
        }
    }
    
    func stopDiscoveringOtherPlayers (){
        getPlayerInfo = false
        stopScan()
        cancelPeripheralConnection(peripheral: connectedPeripheral)
    }
    
    private func onPlayerInfoReceived(receivedDataString data: String, uuid: String){
        
        sendPlayerDataToView(receivedDataString: data, uuid: uuid)
        
        cancelPeripheralConnection(peripheral: connectedPeripheral)
        
        discoverOtherPlayers()
    }
    
    private func sendPlayerDataToView (receivedDataString data: String, uuid: String){
        
        let playerInfo: [String] = data.components(separatedBy: SEPARATOR_NAME_SCORE_ITEMS)
        
        guard playerInfo.count > 2 else {
            print("playerInfo is too short")
            return
        }
        
        guard let scoreInt = Int(playerInfo[DATA_INDEX_SCORE]) else {
            print("no valid color received")
            return
        }
        
        let colorUI = UIColor(hexString: playerInfo[DATA_INDEX_COLOR])
        
        print("player details discovered. name: \(playerInfo[DATA_INDEX_NAME]), score: \(playerInfo[DATA_INDEX_SCORE])")
        
        delegate?.onPlayerDiscovered (name: playerInfo[DATA_INDEX_NAME], score: scoreInt, color: colorUI, uuid: uuid)
    }
    
    private func stopScan() {
        if (centralManager?.isScanning)! {
            centralManager?.stopScan()
        }
    }

    
    func onItemsAndAvatarReceived(uuid: String) {
        let data: [String] = [String(data: dataPlayer.copy() as! Data, encoding: String.Encoding.utf8)!]
        
        let itemStrings: [String] = data[DATA_INDEX_ITEMS].components(separatedBy: SEPARATOR_NAME_SCORE_ITEMS)
        
        var items: [Item] = []
        
        for itemString in itemStrings {
            let item = Item.decode(toDecode: itemString)
            if item != nil {
                items.append(item!)
            }
            else {print("item decoding not successful")}
        }
        
        delegate?.onItemsAndAvatarReceived(items: items, avatar: data[DATA_INDEX_AVATAR])
    }
    
    
    func sendScore (score value: Double) {
        let string: String = String(value)
        if writeScore != nil {
            
            connectedPeripheral?.setNotifyValue(true, for: writeScore!) // TOCO check if necessary
            writeToPeripheral(onCharacteristic: writeScore!, toWrite: string)
        } else {
            print("characteristic writeScore or peripheral not known :(")
        }
        
    }
    
    func sendAttack (itemToBeStolen: Item){
        let itemString: String = itemToBeStolen.toString()
        if writeAttack != nil {
            connectedPeripheral?.setNotifyValue(true, for: writeAttack!) // TOCO check if necessary
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
        for peripheral: CBPeripheral in knownPeripherals {
            if peripheral.identifier.uuidString == uuid {
                
                centralManager?.connect(peripheral, options: nil)
                print("connect to " + uuid)
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
        //delegate?.onConnectionEstablished(uuid: peripheral.identifier.uuidString)
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
        discoveredPeripheral = peripheral
        
        for service in services {
            if getPlayerInfo {
                dataPlayer.length = 0
                peripheral.discoverCharacteristics([playerCharacteristicUUID], for: service)
            }
            else {
                peripheral.discoverCharacteristics([scoreWriteCharacteristicUUID,scoreReadCharacteristicUUID, attackCharacteristicUUID, itemsCharacteristicUUID], for: service)
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
                //delegate?.didDiscoverWriteScroreCharacteristic(characteristic: characteristic)
                break
            case attackCharacteristicUUID:
                print("CM found writeAttackCharacteristic")
                //delegate?.didDiscoverWriteAttackCharacteristic(characteristic: characteristic)
                break
            default:
                print("CM found unidentified Characteristic with uuid " + characteristic.uuid.uuidString)
                
                
            }
            
            peripheral.setNotifyValue(true, for: characteristic)
            
        }
        // Once this is complete, we just need to wait for the data to come in.
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
        
        
        
        guard let stringFromData = String(data: characteristic.value!, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue)) else {
            print("Invalid data")
            return
        }
        
        // Have we got everything we need?
        if stringFromData.isEqual("EOM") {
            // We have, so show the data
            
            
            switch characteristic.uuid {
            case playerCharacteristicUUID:
                print("EOM from player characteristic received")
                onPlayerInfoReceived(receivedDataString: stringFromData, uuid: peripheral.identifier.uuidString)
                break
            case scoreReadCharacteristicUUID:
                let dataString = String (data: dataPlayer as Data, encoding: String.Encoding.utf8)
                let score = Double(dataString!)
                if score != nil {
                    delegate?.onReceiveScoreFromEnemy(score: score!)
                }
                break
            case itemsCharacteristicUUID:
                onItemsAndAvatarReceived(uuid: peripheral.identifier.uuidString)
                break
            default:
                break
            }
            
            
            
            peripheral.setNotifyValue(false, for: characteristic)
            dataPlayer.length = 0

            
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
    
    fileprivate func cancelPeripheralConnection(peripheral: CBPeripheral?) {
        // If we've got this far, we're connected, but we're not subscribed, so we just disconnect
        if peripheral != nil {
            centralManager?.cancelPeripheralConnection(peripheral!)
        }
        connectedPeripheral = nil
    }
    
}
