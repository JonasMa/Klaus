//
//  SimonSaysModel.swift
//  SimonSays
//
//  Created by Verena Schlott on 05.01.17.
//  Copyright (c) 2017 Verena Schlott. All rights reserved.
//

import Foundation
import AudioToolbox

class SimonSaysModel {
    
    let maxNumberOfRounds = 20
    let digitsForCode = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "*", "#"]
    
    var round = 0
    var numClicks = 0
    var score = 0
    
    var code = [String]()
    var userCode = [String]()
    
    init() {
        code = []
        userCode = []
        round = 0
        numClicks = 0
        score = 0
    }
    
    // only for test -> needs to be deleted when result view exists
    func startNewGame() {
        code = []
        userCode = []
        round = 0
        numClicks = 0
        score = 0
    }
    
    // Starts new round if game isn't yet successfully finished
    func computersTurn() -> Bool {
        if round < maxNumberOfRounds {
            nextRound()
            return true
        } else {
            return false
        }
    }
    
    // Adds random digit to code, increments the number of rounds, resets number of user clicks
    func nextRound(){
        let randomIndex = Int(arc4random_uniform(UInt32(digitsForCode.count)))
        code.append(digitsForCode[randomIndex])
        round += 1
        numClicks = 0
    }
    
    // Increments the number of clicks & computes user input:
    // scenario 1: player clicked the right button, but is not yet finished
    // scenario 2: player clicked the right button and is finished
    // scenario 3: player clicked the wrong button
    func playersTurn(playerInput: String) -> String{
        numClicks += 1
        
        if (playerInput == code[numClicks - 1] && numClicks < code.count) {
            return "not finished"
        } else if (playerInput == code[numClicks - 1]){
            score += 1
            return "right"
        } else {
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            return "wrong"
        }
    }
}
