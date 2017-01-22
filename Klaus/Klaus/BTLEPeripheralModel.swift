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
    
    fileprivate var dataToSend: Data?
    fileprivate var sendDataIndex: Int?
    
    private var isAtvertising: Bool

    override init (){
        isAtvertising = false
        super.init()
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
    }
    
    func setActive (){
        startStopAdvertising(true)
    }
    
    func setInactive (){
        startStopAdvertising(false)
    }
    
    func getItemsString (items: [Item]) -> String{
        var itemStrings = Array<String>()
        for item in items {
            let stringy = item.toString()
            itemStrings.append(stringy)
        }
        
        return itemStrings.joined(separator: Item.ITEM_SEPARATOR)
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
        
        // Start with the CBMutableCharacteristic
        playerCharacteristic = CBMutableCharacteristic(
            type: playerCharacteristicUUID,
            properties: CBCharacteristicProperties.notify,
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
        
        let sendString = AppModel.sharedInstance.player.name + SEPARATOR_NAME_SCORE_ITEMS + String(AppModel.sharedInstance.player.score) + SEPARATOR_NAME_SCORE_ITEMS + getItemsString(items: AppModel.sharedInstance.player.items)
        
        dataToSend = sendString.data(using: String.Encoding.utf8)
        
        // Reset the index
        sendDataIndex = 0;
        
        // Start sending
        sendData(forCharacteristic: playerCharacteristic)
    }
    
    /** Recognise when the central unsubscribes
     */
    func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didUnsubscribeFrom characteristic: CBCharacteristic) {
        print("Central unsubscribed from characteristic")
    }
    
    // First up, check if we're meant to be sending an EOM
    fileprivate var sendingEOM = false;
    
    /** Sends the next amount of data to the connected central
     */
    fileprivate func sendData(forCharacteristic: CBMutableCharacteristic?) {
        if sendingEOM {
            // send it
            let didSend = peripheralManager?.updateValue(
                "EOM".data(using: String.Encoding.utf8)!,
                for: forCharacteristic!,
                onSubscribedCentrals: nil
            )
            
            // Did it send?
            if (didSend == true) {
                
                // It did, so mark it as sent
                sendingEOM = false
                
                print("Sent: EOM")
            }
            
            // It didn't send, so we'll exit and wait for peripheralManagerIsReadyToUpdateSubscribers to call sendData again
            return
        }
        
        // We're not sending an EOM, so we're sending data
        
        // Is there any left to send?
        guard sendDataIndex! < (dataToSend?.count)! else {
            // No data left.  Do nothing
            return
        }
        
        // There's data left, so send until the callback fails, or we're done.
        var didSend = true
        
        while didSend {
            // Make the next chunk
            
            // Work out how big it should be
            var amountToSend = dataToSend!.count - sendDataIndex!;
            
            // Can't be longer than 20 bytes
            if (amountToSend > NOTIFY_MTU) {
                amountToSend = NOTIFY_MTU;
            }
            
            let ptr = ((dataToSend! as NSData).bytes + sendDataIndex!).assumingMemoryBound(to: UInt8.self)
            // Copy out the data we want
            let chunk = Data(
                bytes: ptr, //UnsafePointer<UInt8>((dataToSend! as NSData).bytes + sendDataIndex!),
                count: amountToSend
            )
            
            // Send it
            didSend = peripheralManager!.updateValue(
                chunk,
                for: forCharacteristic!,
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
            if (sendDataIndex! >= dataToSend!.count) {
                
                // It was - send an EOM
                
                // Set this so if the send fails, we'll send it next time
                sendingEOM = true
                
                // Send it
                let eomSent = peripheralManager!.updateValue(
                    "EOM".data(using: String.Encoding.utf8)!,
                    for: forCharacteristic!,
                    onSubscribedCentrals: nil
                )
                
                if (eomSent) {
                    // It sent, we're all done
                    sendingEOM = false
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
        sendData(forCharacteristic: playerCharacteristic)
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
                peripheralManager!.startAdvertising([
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
    
}
