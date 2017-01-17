//
//  ShelfGameLogic.swift
//  Klaus
//
//  Created by Oliver Pieper on 13.01.17.
//  Copyright © 2017 Nimm Swag. All rights reserved.
//

import Foundation

class ShelfGameLogic {
    
    static var selectedItemCount: Int = 0
    
    var itemIDCount: Int = 0
    var shelfGameVC: ShelfGameViewController!
    static var initializedItems: [DropItemModel] = []
    var currentItem: DropItemModel!
    static var timer = Timer.init()
    
    init() {
   
    }
    
    func setVC(vc: ShelfGameViewController){
        self.shelfGameVC = vc
        ShelfGameLogic.timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.update), userInfo: nil, repeats: true);
    }
    
    @objc func update() {
        itemIDCount += 1
        currentItem = DropItemModel(id: itemIDCount)
        ShelfGameLogic.initializedItems.append(currentItem)
        shelfGameVC.view.addSubview(currentItem)
    }
    
    static func increaseSelectedItemCount() {
        selectedItemCount += 1
        NSLog("Item Count: \(selectedItemCount)")
        if selectedItemCount == 3 {
            for item in initializedItems {
                if item.isPaused() {
                    item.killItem()
                }
            }
            selectedItemCount = 0
        }
    }
    
    static func killGame(){
        ShelfGameLogic.timer.invalidate()
    }
    
    static func decreaseSelectedItemCount() {
        selectedItemCount -= 1
        NSLog("Item Count decreased: \(selectedItemCount)")
    }
}
