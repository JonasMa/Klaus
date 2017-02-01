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
    
    let threshold: Double = 0.7
    
    var currentX: Double = 0.0
    var currentY: Double = 0.0
    var currentZ: Double = 0.0
    var maxX: Double = 0.0
    var maxY: Double = 0.0
    var maxZ: Double = 0.0
    var axe: AxeModel!
    var axeStarted: Bool = false
    
    //Implements MotionManager, needed for calling accelerometer data and starts recording
    init(axeModel: AxeModel) {
        self.axe = axeModel
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
        
        if !axeStarted {
            if ((maxX + maxY + maxZ)/3) > threshold {
                axe.animateAxe()
                axeStarted = true
            }
        }
        
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
