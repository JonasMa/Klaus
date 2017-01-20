//
//  BTLECentralModel.swift
//  Klaus
//
//  Created by Jonas Programmierer on 15.01.17.
//  Copyright © 2017 Nimm Swag. All rights reserved.
//

import CoreBluetooth


class BTLECentralModel: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    //static let sharedInstance = BTLECentralModel()
    
    fileprivate var centralManager: CBCentralManager?
    fileprivate var discoveredPeripheral: CBPeripheral?
    
    var delegate: ConnectingDelegate?
    
    var isAvailable: Bool = false
    var isActive: Bool = false
    
    var currentEnemyProfile: EnemyProfile?
    
    var knownPeripherals: [CBPeripheral] = []
    
    // And somewhere to store the incoming data
    fileprivate let data = NSMutableData()
    
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
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
            withServices: [transferServiceUUID], options: [
                CBCentralManagerScanOptionAllowDuplicatesKey : NSNumber(value: true as Bool)
            ]
        )
        
        print("Scanning started")
    }
    
    
    func connectToPeripheral (uuid: String){
        
        for peripheral: CBPeripheral in knownPeripherals {
            if peripheral.identifier.uuidString == uuid {
                centralManager?.connect(peripheral, options: nil)
                return
            }
        }
        print("no matching peripheral found for uuid " + uuid)
    }
    
    /** This callback comes whenever a peripheral that is advertising the TRANSFER_SERVICE_UUID is discovered.
     *  We check the RSSI, to make sure it's close enough that we're interested in it, and if it is,
     *  we start the connection process
     */
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        // Reject any where the value is above reasonable range
        // Reject if the signal strength is too low to be close enough (Close is around -22dB)
        
        //        if  RSSI.integerValue < -15 && RSSI.integerValue > -35 {
        //            println("Device not at correct range")
        //            return
        //        }

        // Ok, it's in range - have we already seen it?
        
        
        if discoveredPeripheral != peripheral {
            
            print("Discovered new \(peripheral.name) with uuid \(peripheral.identifier.uuidString)")
            print("Data: " + advertisementData.description)
            
            knownPeripherals.append(peripheral)
            // Save a local copy of the peripheral, so CoreBluetooth doesn't get rid of it
            discoveredPeripheral = peripheral
            // And connect
            //print("Connecting to peripheral \(peripheral)")
            
            //centralManager?.connect(peripheral, options: nil)
            // TODO connect on enemy select
            var name: String
            if let pName = peripheral.name {
                name = pName
            }
            else {
                name = DEFAULT_NAME //defaultName declared in Definitions
            }
            let profile = EnemyProfile(name: name)
            print("Enemy seen!! " + name)
            AppModel.sharedInstance.addEnemyToList(enemy: profile)
        }
    }
    
    /** If the connection fails for whatever reason, we need to deal with it.
     */
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("Failed to connect to \(peripheral). (\(error!.localizedDescription))")
        
        cleanup()
    }
    
    /** We've connected to the peripheral, now we need to discover the services and characteristics to find the 'transfer' characteristic.
     */
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Peripheral Connected")
        
        // Stop scanning
        if centralManager!.isScanning {
            centralManager?.stopScan()
            print("Scanning stopped")
        }
        
        // Clear the data that we may already have
        data.length = 0
        
        // Make sure we get the discovery callbacks
        peripheral.delegate = self
        
        // Search only for services that match our UUID
        peripheral.discoverServices([transferServiceUUID])
    }
    
    /** The Transfer Service was discovered
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
        for service in services {
            peripheral.discoverCharacteristics([transferCharacteristicUUID], for: service)
        }
    }
    
    /** The Transfer characteristic was discovered.
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
            if characteristic.uuid.isEqual(transferCharacteristicUUID) {
                // If it is, subscribe to it
                peripheral.setNotifyValue(true, for: characteristic)
            }
        }
        // Once this is complete, we just need to wait for the data to come in.
    }
    
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
            // We have, so show the data,
            //textView.text = String(data: data.copy() as! Data, encoding: String.Encoding.utf8)
            
            // TODO send data string to wherever (siehe oben)
            // with delegate methods
            let name: String = String(data: data.copy() as! Data, encoding: String.Encoding.utf8)!
            
            delegate?.didRetrievePlayerInfo(name: name)
            // TODO define info
            
            
            // Cancel our subscription to the characteristic
            peripheral.setNotifyValue(false, for: characteristic)
            
            // and disconnect from the peripehral
            centralManager?.cancelPeripheralConnection(peripheral)
        } else {
            // Otherwise, just add the data on to what we already have
            data.append(characteristic.value!)
            
            // Log it
            print("Received: \(stringFromData)")
        }
    }
    
    /** The peripheral letting us know whether our subscribe/unsubscribe happened or not
     */
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        print("Error changing notification state: \(error?.localizedDescription)")
        
        // Exit if it's not the transfer characteristic
        guard characteristic.uuid.isEqual(transferCharacteristicUUID) else {
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
        
        // We're disconnected, so start scanning again
        scan()
    }
    
    /** Call this when things either go wrong, or you're done with the connection.
     *  This cancels any subscriptions if there are any, or straight disconnects if not.
     *  (didUpdateNotificationStateForCharacteristic will cancel the connection if a subscription is involved)
     */
    fileprivate func cleanup() {
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
                if characteristic.uuid.isEqual(transferCharacteristicUUID) && characteristic.isNotifying {
                    discoveredPeripheral?.setNotifyValue(false, for: characteristic)
                    // And we're done.
                    return
                }
            }
        }
    }
    
    fileprivate func cancelPeripheralConnection() {
        // If we've got this far, we're connected, but we're not subscribed, so we just disconnect
        centralManager?.cancelPeripheralConnection(discoveredPeripheral!)
    }

}