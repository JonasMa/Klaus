//
//  ShelfGameLogic.swift
//  Klaus
//
//  Created by Oliver Pieper on 13.01.17.
//  Copyright © 2017 Nimm Swag. All rights reserved.
//

import Foundation
import AudioToolbox

class ShelfGameLogic {
    
    static var selectedItemCount: Int = 0
    static var score: Double = 0
    var shelfGameVC: ShelfGameViewController!
    static var initializedItems: [DropItemModel] = []
    var currentItem: DropItemModel!
    static var timer = Timer.init()
    static var speed: Double = 1.0
    
    static var gameOverYet: Bool = false
    
    init() {
   
    }
    
    func setVC(vc: ShelfGameViewController){
        self.shelfGameVC = vc
        ShelfGameLogic.timer = Timer.scheduledTimer(timeInterval: ShelfGameLogic.speed, target: self, selector: #selector(self.update), userInfo: nil, repeats: false);
    }
    
    @objc func update() {
        currentItem = DropItemModel()
        ShelfGameLogic.initializedItems.append(currentItem)
        shelfGameVC.view.addSubview(currentItem)
        ShelfGameLogic.timer = Timer.scheduledTimer(timeInterval: ShelfGameLogic.speed, target: self, selector: #selector(self.update), userInfo: nil, repeats: false);
        if ShelfGameLogic.gameOverYet {
            shelfGameVC.onItemTouchedFloor(score: ShelfGameLogic.score)
            gameOver()
        }
    }
    
    static func increaseSelectedItemCount() {
        selectedItemCount += 1
        if selectedItemCount > 2 {
            for item in initializedItems {
                if item.isPaused() {
                    item.killItem()
                }
            }
            selectedItemCount = 0
            score += 1.0
            if speed > 0.6 {
                speed -= 0.1
                NSLog("Speed: \(speed)")
            }
            AudioServicesPlaySystemSound(1016)
        }
        NSLog("Score: \(score)")
        NSLog("Speed: \(speed)")
    }
    
    func gameOver(){
        NSLog("Game Over")
        ShelfGameLogic.timer.invalidate()
        for item in ShelfGameLogic.initializedItems {
            item.killItem()
        }
    }
    
    static func getScore() -> Double{
        return score
    }
    
    static func decreaseSelectedItemCount() {
        selectedItemCount -= 1
    }
}
