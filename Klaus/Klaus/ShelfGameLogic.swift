//
//  ShelfGameLogic.swift
//  Klaus
//
//  Created by Oliver Pieper on 13.01.17.
//  Copyright © 2017 Nimm Swag. All rights reserved.
//

import Foundation
import AudioToolbox
import UIKit

class ShelfGameLogic {
    
    var selectedItemCount: Int = 0
    var score: Double = 0
    var shelfGameVC: ShelfGameViewController!
    var initializedItems: [DropItemModel] = []
    var currentItem: DropItemModel!
    var timer = Timer.init()
    var speed: Double = 1.0
    
    var gameOverYet: Bool = false
    
    init(vc: ShelfGameViewController) {
        initGameVariables()
        self.shelfGameVC = vc        
        timer = Timer.scheduledTimer(timeInterval: speed, target: self, selector: #selector(self.update), userInfo: nil, repeats: false);
    }
    
    @objc func update() {
        currentItem = DropItemModel(logic: self)
        initializedItems.append(currentItem)
        shelfGameVC.view.addSubview(currentItem)
        timer = Timer.scheduledTimer(timeInterval: speed, target: self, selector: #selector(self.update), userInfo: nil, repeats: false);
        if gameOverYet {
            shelfGameVC.onItemTouchedFloor(score: score)
            gameOver()
        }
    }
    
    func initGameVariables() {
        initializedItems.removeAll()
        selectedItemCount = 0
        score = 0
        speed = 1.0
        gameOverYet = false
    }
    
    func increaseSelectedItemCount() {
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
        timer.invalidate()
        for item in initializedItems {
            item.killItem()
        }
    }
    
    func decreaseSelectedItemCount() {
        selectedItemCount -= 1
    }
}
