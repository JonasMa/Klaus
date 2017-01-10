//
//  AccelerometerModel.swift
//  Klaus
//
//  Created by Oliver Pieper on 29.12.16.
//  Copyright © 2016 Nimm Swag. All rights reserved.
//

import Foundation
import CoreMotion

class AccelerometerModel {
    
    var motionManager: CMMotionManager!
    
    var currentX: Double = 0.0
    var currentY: Double = 0.0
    var currentZ: Double = 0.0
    var maxX: Double = 0.0
    var maxY: Double = 0.0
    var maxZ: Double = 0.0
    
    //Implements MotionManager, needed for calling accelerometer data and starts recording
    init() {
        motionManager = CMMotionManager()
        motionManager.accelerometerUpdateInterval = 0.2
        motionManager.startAccelerometerUpdates(to: OperationQueue.main) { [weak self] (data: CMAccelerometerData?, error: Error?) in
            self!.outputAccelerationData(acceleration: data!.acceleration)
        }
    }
    
    //Retrieves accelerometer data and stores it in global vars
    func outputAccelerationData(acceleration: CMAcceleration){
        currentX = acceleration.x
        currentY = acceleration.y
        currentZ = acceleration.z
        
        if (currentX > maxX) {
            maxX = currentX
        }
        
        if (currentY > maxY) {
            maxY = currentY
        }
        
        if (currentZ > maxZ) {
            maxZ = currentZ
        }
    }
    
    //Gets called by axe minigame controller, stops recording
    func endRecording () -> Double{
        return (maxX + maxY + maxZ)/3
    }
    
}
