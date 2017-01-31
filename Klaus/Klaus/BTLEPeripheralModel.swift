//
//  BTLEPeripheralModel.swift
//  Klaus
//
//  Created by Jonas Programmierer on 15.01.17.
//  Copyright © 2017 Nimm Swag. All rights reserved.
//

import UIKit
import CoreBluetooth


class BTLEPeripheralModel : NSObject, CBPeripheralManagerDelegate {
    
    // characteristics of peripheral
    private var peripheralManager: CBPeripheralManager?
    private var playerCharacteristic: CBMutableCharacteristic?
    private var itemsCharacteristic: CBMutableCharacteristic?
    private var attackCharacteristic: CBMutableCharacteristic?
    private var readScoreCharacteristic: CBMutableCharacteristic?
    private var writeScoreCharacteristic: CBMutableCharacteristic?
    
    // fata vars
    private var sendingData: Data?
    private var sendDataIndex: Int?
    private var sendingEOM = false;
    
    var delegate: BluetoothPeripheralDelegate?
    
    private var isAtvertising: Bool
    private var sendingCharacteristic: CBMutableCharacteristic?
    
    override init (){
        isAtvertising = false
        sendDataIndex = 0
        super.init()
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
    }
   
    /**
        PUBLIC FUNCTIONS
     */
    
    func setActive (){
        startStopAdvertising(doAdvertise: true)
    }
    
    func setInactive (){
        startStopAdvertising(doAdvertise: false)
    }
    
    func setOwnScore (score: Double){
        print("PM set own score on readScoreCharacteristic")
        sendingData = String(score).data(using: String.Encoding.utf8)
        sendData(forCharacteristic: readScoreCharacteristic)
    }
    
    /*
        PRIVATE FUNCTIONS
    */
    
    private func onReceiveWriteFromCentral (dataString: String, uuid: CBUUID) {
        switch uuid {
            
        case attackCharacteristicUUID:
            guard let item = Item.decode(toDecode: dataString) else {
                print("PM item not decodable in attack request. \(dataString)")
                return
            }
            print("PM received on attackCharacteristic: item name: \(item.displayName)")
            delegate?.receiveGameRequestFromAttacker(itemToBeStolen: item)
            break
            
        case scoreWriteCharacteristicUUID:
            guard let score = Double(dataString) else {
                print("PM double not decodable in attack request. \(dataString)")
                return
            }
            print("PM received on scoreCharacteristic: \(score)")
            delegate?.onReceiveScoreFromEnemy(score: score)
            break
            
        default:
            print("PM write request on unknown characterisitc. value: \(dataString)")
            break
        }
    }
    
    private func startStopAdvertising (doAdvertise: Bool) {
        
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
    
    private func sendNextDataChunk (){
        if sendingCharacteristic != nil {
            sendData(forCharacteristic: sendingCharacteristic!)
        }
    }
    
    private func sendDataToCharacteristic(characteristicUUID: CBUUID) {
        var sendString: String?
        
        switch characteristicUUID {
        case (playerCharacteristic?.uuid)!:
            sendString = AppModel.sharedInstance.player.name + SEPARATOR_NAME_SCORE_ITEMS + String(AppModel.sharedInstance.player.profileLevel) + SEPARATOR_NAME_SCORE_ITEMS + AppModel.sharedInstance.player.profileColor.toHexString() + SEPARATOR_NAME_SCORE_ITEMS + AppModel.sharedInstance.player.profileAvatar
            sendingCharacteristic = playerCharacteristic
            break
        case (readScoreCharacteristic?.uuid)!:
            break
        case (writeScoreCharacteristic?.uuid)!:
            // WRITE ONLY, see peripheralManager(_ peripheral: CBPeripheralManager, didReceiveWrite requests: [CBATTRequest])
            break
        case (attackCharacteristic?.uuid)!:
            // WRITE ONLY see peripheralManager(_ peripheral: CBPeripheralManager, didReceiveWrite requests: [CBATTRequest])
            break
        case (itemsCharacteristic?.uuid)!:
            sendString = AppModel.sharedInstance.player.getItemsString()
            sendingCharacteristic = itemsCharacteristic
            print("PM send own Items")
            break
        default:
            print("PM no uuid matching characteristic.uuid (\(characteristicUUID.uuidString))")
        }
        
        if sendString != nil {
            sendingData = sendString!.data(using: String.Encoding.utf8)
            
            // Start sending
            sendData(forCharacteristic: sendingCharacteristic)
        }
        
    }
    
    private func createCharacteristics() -> [CBMutableCharacteristic] {
        playerCharacteristic = CBMutableCharacteristic(
            type: playerCharacteristicUUID,
            properties: CBCharacteristicProperties.notify,
            value: nil,
            permissions: CBAttributePermissions.readable
        )
        
        attackCharacteristic = CBMutableCharacteristic(
            type: attackCharacteristicUUID,
            properties: CBCharacteristicProperties.write,
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
            properties: CBCharacteristicProperties.write, // TODO: check if .write is necessary
            value: nil,
            permissions: CBAttributePermissions.writeable
        )
        
        itemsCharacteristic = CBMutableCharacteristic(
            type: itemsCharacteristicUUID,
            properties: CBCharacteristicProperties.notify, // TODO: check if .write is necessary
            value: nil,
            permissions: CBAttributePermissions.readable
        )
        
        return [playerCharacteristic!, attackCharacteristic!, readScoreCharacteristic!, writeScoreCharacteristic!, itemsCharacteristic!]

    }
    
    /** Sends the next amount of data to the connected central
     */
    private func sendData(forCharacteristic: CBMutableCharacteristic?) {
        guard let characteristic = forCharacteristic else {
            print("PM Error unwrapping characteristic")
            return
        }
        if sendingCharacteristic == nil {
            sendingCharacteristic = characteristic
        }
        
        if sendingEOM {
            
            sendEom(forCharacteristic: characteristic)
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
            // Work out how big it should be
            var amountToSend = sendingData!.count - sendDataIndex!;
            // Can't be longer than 20 bytes
            if (amountToSend > NOTIFY_MTU) {
                amountToSend = NOTIFY_MTU;
            }
            let chunk = getNextChunk(amountToSend: amountToSend)
            
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
            
            print("PM Sent: \(stringFromData)")
            
            // It did send, so update our index
            sendDataIndex! += amountToSend;
            
            // Was it the last one?
            if (sendDataIndex! >= sendingData!.count) {
                
                // It was - send an EOM
                sendEom(forCharacteristic: characteristic)
                
                // Set this so if the send fails, we'll send it next time
                return
            }
        }
    }
    
    private func sendEom (forCharacteristic: CBMutableCharacteristic) {
        sendingEOM = true
        
        // Send it
        let eomSent = peripheralManager!.updateValue(
            "EOM".data(using: String.Encoding.utf8)!,
            for: forCharacteristic,
            onSubscribedCentrals: nil
        )
        
        if (eomSent) {
            // It sent, we're all done
            sendingEOM = false
            sendingCharacteristic = nil
            sendDataIndex = 0
            sendingData?.count = 0
            print("PM Sent: EOM")
        }
        

    }
    
    
    private func getNextChunk (amountToSend: Int) -> Data{
        
        let ptr = ((sendingData! as NSData).bytes + sendDataIndex!).assumingMemoryBound(to: UInt8.self)
        // Copy out the data we want
        return Data(
            bytes: ptr, //UnsafePointer<UInt8>((dataToSend! as NSData).bytes + sendDataIndex!),
            count: amountToSend
        )
    }

    
    /*
        DELEGATE METHODS
     */
    
    /** Required protocol method.  A full app should take care of all the possible states,
     *  but we're just waiting for  to know when the CBPeripheralManager is ready
     */
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        // Opt out from any other state
        if #available(iOS 10.0, *) {
            if (peripheral.state != CBManagerState.poweredOn) {
                print("PM CBManagerState != poweredOn")
                return
            }
        } else {
            print("PM TOO OLD IOS! ALARM!")
            // Fallback on earlier versions
        }
        
        // We're in CBPeripheralManagerStatePoweredOn state...
        print("PM self.peripheralManager powered on.")
        
        // Then the service
        let playerService = CBMutableService(
            type: playerServiceUUID,
            primary: true
        )
        
        // Add the characteristic to the service
        playerService.characteristics = createCharacteristics()
        
        // And add it to the peripheral manager
        peripheralManager!.add(playerService)
        
        if isAtvertising {
            startStopAdvertising(doAdvertise: true)
        }
    }
    
    
    /** Catch when someone subscribes to our characteristic, then start sending them data
     */
    func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didSubscribeTo characteristic: CBCharacteristic) {
        print("PM Central subscribed to characteristic")
        sendDataToCharacteristic(characteristicUUID: characteristic.uuid)
    }
    
    
    
    /** Recognise when the central unsubscribes
     */
    func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didUnsubscribeFrom characteristic: CBCharacteristic) {
        print("PM Central unsubscribed from characteristic")
    }

    
    /** This callback comes in when the PeripheralManager is ready to send the next chunk of data.
     *  This is to ensure that packets will arrive in the order they are sent
     */
    func peripheralManagerIsReady(toUpdateSubscribers peripheral: CBPeripheralManager) {
        // Start sending again
        sendNextDataChunk()
    }
    
    
    func peripheralManagerDidStartAdvertising(_ peripheral: CBPeripheralManager, error: Error?) {
        print(error ?? "start advertising")
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveWrite requests: [CBATTRequest]) {
        print("PM write request received: " + requests.description)
        
        guard let dataString = String(data: requests[0].value!, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue)) else {
            print("PM data empty or not stringable. \(requests.description)")
            return
        }
        
        onReceiveWriteFromCentral(dataString: dataString, uuid: requests[0].characteristic.uuid)
    }
    
}
