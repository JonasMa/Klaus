//
//  BTLEPeripheralModel.swift
//  Klaus
//
//  Created by Jonas Programmierer on 15.01.17.
//  Copyright © 2017 Nimm Swag. All rights reserved.
//
// In structure it is based on
// https://github.com/0x7fffffff/Core-Bluetooth-Transfer-Demo
// which itself is a translation from
// https://developer.apple.com/library/ios/samplecode/BTLE_Transfer/Introduction/Intro.html

import UIKit
import CoreBluetooth

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}


class BTLEPeripheralModel : NSObject, CBPeripheralManagerDelegate {
    
    fileprivate var peripheralManager: CBPeripheralManager?
    fileprivate var playerCharacteristic: CBMutableCharacteristic?
    fileprivate var itemsCharacteristic: CBMutableCharacteristic?
    fileprivate var attackCharacteristic: CBMutableCharacteristic?
    fileprivate var readScoreCharacteristic: CBMutableCharacteristic?
    fileprivate var writeScoreCharacteristic: CBMutableCharacteristic?
    
    //fileprivate var dataPlayer: Data?
    //fileprivate var dataScore: Data?
    //fileprivate var dataItems: Data?
    fileprivate var sendingData: Data?
    fileprivate var sendDataIndex: Int?
    fileprivate var sendDataIndexScore: Int?
    fileprivate var sendDataIndexItems: Int?
    
    private var isAtvertising: Bool
    private var sendingCharacteristic: CBMutableCharacteristic?

    override init (){
        isAtvertising = false
        sendDataIndex = 0
        super.init()
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
    }
    
    func setActive (){
        startStopAdvertising(true)
    }
    
    func setInactive (){
        startStopAdvertising(false)
    }
    
    func setOwnScore (score: Double){
        sendingData = String(score).data(using: String.Encoding.utf8)
        sendData(forCharacteristic: readScoreCharacteristic)
    }
    
    
    /** Required protocol method.  A full app should take care of all the possible states,
     *  but we're just waiting for  to know when the CBPeripheralManager is ready
     */
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        // Opt out from any other state
        if #available(iOS 10.0, *) {
            if (peripheral.state != CBManagerState.poweredOn) {
                print("CBManagerState != poweredOn")
                return
            }
        } else {
            print("TOO OLD IOS! ALARM!")
            // Fallback on earlier versions
        }
        
        // We're in CBPeripheralManagerStatePoweredOn state...
        print("self.peripheralManager powered on.")
        
        // ... so build our service.
        
        let playerString: String = AppModel.sharedInstance.player.name + SEPARATOR_NAME_SCORE_ITEMS + String(AppModel.sharedInstance.player.score)
        let playerData: Data = playerString.data(using: String.Encoding.utf8)!
        
        // Start with the CBMutableCharacteristic
        playerCharacteristic = CBMutableCharacteristic(
            type: playerCharacteristicUUID,
            properties: CBCharacteristicProperties.notify,
            value: playerData,
            permissions: CBAttributePermissions.readable
        )
        
        attackCharacteristic = CBMutableCharacteristic(
            type: attackCharacteristicUUID,
            properties: CBCharacteristicProperties.notify,
            value: nil,
            permissions: CBAttributePermissions.writeable
        )
        
        readScoreCharacteristic = CBMutableCharacteristic(
            type: scoreReadCharacteristicUUID,
            properties: CBCharacteristicProperties.notify,
            value: nil,
            permissions: CBAttributePermissions.readable
        )
        
        writeScoreCharacteristic = CBMutableCharacteristic(
            type: scoreWriteCharacteristicUUID,
            properties: CBCharacteristicProperties.notify, // TODO: check if .write is necessary
            value: nil,
            permissions: CBAttributePermissions.writeable
        )
        
        itemsCharacteristic = CBMutableCharacteristic(
            type: itemsCharacteristicUUID,
            properties: CBCharacteristicProperties.notify, // TODO: check if .write is necessary
            value: nil,
            permissions: CBAttributePermissions.readable
        )

        
        // Then the service
        let transferService = CBMutableService(
            type: playerServiceUUID,
            primary: true
        )
        
        // Add the characteristic to the service
        transferService.characteristics = [playerCharacteristic!]
        transferService.characteristics = [attackCharacteristic!]
        transferService.characteristics = [readScoreCharacteristic!]
        transferService.characteristics = [writeScoreCharacteristic!]
        transferService.characteristics = [itemsCharacteristic!]
        
        // And add it to the peripheral manager
        peripheralManager!.add(transferService)
        
        if isAtvertising {
            startStopAdvertising(true)
        }
    }
    
    /** Catch when someone subscribes to our characteristic, then start sending them data
     */
    func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didSubscribeTo characteristic: CBCharacteristic) {
        print("Central subscribed to characteristic")
        
        var sendString: String?
        //var data: Data?
        
        switch characteristic.uuid {
        case (playerCharacteristic?.uuid)!:
            sendString = AppModel.sharedInstance.player.name + SEPARATOR_NAME_SCORE_ITEMS + String(AppModel.sharedInstance.player.getAcquiredScore()) // + SEPARATOR_NAME_SCORE_ITEMS + AppModel.sharedInstance.player.getItemsString()
            sendingCharacteristic = playerCharacteristic
            break
        case (readScoreCharacteristic?.uuid)!:
            break
        case (writeScoreCharacteristic?.uuid)!:
            // WRITE ONLY
            //sendingCharacteristic = writeScoreCharacteristic
            break
        case (attackCharacteristic?.uuid)!:
            // WRITE ONLY
            //sendingCharacteristic = attackCharacteristic
            break
        case (itemsCharacteristic?.uuid)!:
            sendString = AppModel.sharedInstance.player.getItemsString()
            sendingCharacteristic = itemsCharacteristic
            print("send own Items")
            break
        default:
            print("no uuid matching characteristic.uuid (\(characteristic.uuid))")
        }
        
        if sendString != nil {
            sendingData = sendString!.data(using: String.Encoding.utf8)
            

            
            // Start sending
            sendData(forCharacteristic: sendingCharacteristic)
        }
    }
    
    
    
    /** Recognise when the central unsubscribes
     */
    func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didUnsubscribeFrom characteristic: CBCharacteristic) {
        print("Central unsubscribed from characteristic")
    }
    
    private func sendNextDataChunk (){
        if sendingCharacteristic != nil {
            sendData(forCharacteristic: sendingCharacteristic!)
        }
    }
    
    // First up, check if we're meant to be sending an EOM
    fileprivate var sendingEOM = false;
    
    /** Sends the next amount of data to the connected central
     */
    fileprivate func sendData(forCharacteristic: CBMutableCharacteristic?) {
        guard let characteristic = forCharacteristic else {
            print("Error unwrapping characteristic")
            return
        }
        if sendingCharacteristic == nil {
            sendingCharacteristic = characteristic
        }
        if sendingEOM {
            // send it
            let didSend = peripheralManager?.updateValue(
                "EOM".data(using: String.Encoding.utf8)!,
                for: characteristic,
                onSubscribedCentrals: nil
            )
            
            // Did it send?
            if (didSend == true) {
                
                // It did, so mark it as sent
                sendingEOM = false
                sendingCharacteristic = nil
                sendDataIndex = 0
                sendingData?.count = 0
                print("Sent: EOM")
            }
            
            // It didn't send, so we'll exit and wait for peripheralManagerIsReadyToUpdateSubscribers to call sendData again
            return
        }
        
        // We're not sending an EOM, so we're sending data
        
        // Is there any left to send?
        guard sendDataIndex! < (sendingData?.count)! else {
            // No data left.  Do nothing
            return
        }
        
        // There's data left, so send until the callback fails, or we're done.
        var didSend = true
        
        while didSend {
            // Make the next chunk
            
            // Work out how big it should be
            var amountToSend = sendingData!.count - sendDataIndex!;
            
            // Can't be longer than 20 bytes
            if (amountToSend > NOTIFY_MTU) {
                amountToSend = NOTIFY_MTU;
            }
            
            let ptr = ((sendingData! as NSData).bytes + sendDataIndex!).assumingMemoryBound(to: UInt8.self)
            // Copy out the data we want
            let chunk = Data(
                bytes: ptr, //UnsafePointer<UInt8>((dataToSend! as NSData).bytes + sendDataIndex!),
                count: amountToSend
            )
            
            // Send it
            didSend = peripheralManager!.updateValue(
                chunk,
                for: characteristic,
                onSubscribedCentrals: nil
            )
            
            // If it didn't work, drop out and wait for the callback
            if (!didSend) {
                return
            }
            
            let stringFromData = NSString(
                data: chunk,
                encoding: String.Encoding.utf8.rawValue
            )
            
            print("Sent: \(stringFromData)")
            
            // It did send, so update our index
            sendDataIndex! += amountToSend;
            
            // Was it the last one?
            if (sendDataIndex! >= sendingData!.count) {
                
                // It was - send an EOM
                
                // Set this so if the send fails, we'll send it next time
                sendingEOM = true
                
                // Send it
                let eomSent = peripheralManager!.updateValue(
                    "EOM".data(using: String.Encoding.utf8)!,
                    for: characteristic,
                    onSubscribedCentrals: nil
                )
                
                if (eomSent) {
                    // It sent, we're all done
                    sendingEOM = false
                    sendingCharacteristic = nil
                    sendDataIndex = 0
                    sendingData?.count = 0
                    print("Sent: EOM")
                }
                
                return
            }
        }
    }
    
    /** This callback comes in when the PeripheralManager is ready to send the next chunk of data.
     *  This is to ensure that packets will arrive in the order they are sent
     */
    func peripheralManagerIsReady(toUpdateSubscribers peripheral: CBPeripheralManager) {
        // Start sending again
        sendNextDataChunk()
    }
    
    /** This is called when a change happens, so we know to stop advertising
     *
    func textViewDidChange(_ textView: UITextView) {
        // If we're already advertising, stop
        if (advertisingSwitch.isOn) {
            advertisingSwitch.setOn(false, animated: true)
            peripheralManager?.stopAdvertising()
        }
    }*/
    
    /** Start/stop advertising
     */
    func startStopAdvertising (_ doAdvertise: Bool) {
        
        isAtvertising = doAdvertise
        if peripheralManager?.state == .poweredOn {
            if doAdvertise && !peripheralManager!.isAdvertising {
                // All we advertise is our service's UUID
                peripheralManager?.startAdvertising([
                    CBAdvertisementDataServiceUUIDsKey : [playerServiceUUID]
                ])
            } else {
                peripheralManager?.stopAdvertising()
                
            }
        }
    }
    
    
    func peripheralManagerDidStartAdvertising(_ peripheral: CBPeripheralManager, error: Error?) {
        print(error ?? "start advertising")
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveWrite requests: [CBATTRequest]) {
        print("write request received: " + requests.description)
    }
    
}
