//
//  ShelfGameLogic.swift
//  Klaus
//
//  Created by Oliver Pieper on 13.01.17.
//  Copyright © 2017 Nimm Swag. All rights reserved.
//

import Foundation

class ShelfGameLogic {
    
    var itemIDCount: Int = 0
    var shelfGameVC: ShelfGameViewController!
    static var selectedItemIDs: [Int] = []
    var initializedItems: [DropItemModel] = []
    var currentItem: DropItemModel!
    var isGameNotOver: Bool = true
    
    init() {
        
        //_ = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.update), userInfo: nil, repeats: true);
        
    }
    
    @objc func update() {
        itemIDCount += 1
        currentItem = DropItemModel(id: itemIDCount)
        initializedItems.append(currentItem)
        shelfGameVC.view.addSubview(currentItem)
        //NSLog("Item Count: "+String(selectedItemIDs.count))
        if ShelfGameLogic.selectedItemIDs.count == 3 {
            let i = initializedItems.index(where: {$0.getID() == ShelfGameLogic.selectedItemIDs[0]})
            NSLog("Index: \(i)")
            let h = initializedItems.index(where: {$0.getID() == ShelfGameLogic.selectedItemIDs[1]})
            NSLog("Index: \(h)")
            let j = initializedItems.index(where: {$0.getID() == ShelfGameLogic.selectedItemIDs[2]})
            NSLog("Index: \(j)")
            initializedItems[i!].killItem()
            initializedItems[h!].killItem()
            initializedItems[j!].killItem()
        }
    }
    
    func setVC(vc: ShelfGameViewController){
        self.shelfGameVC = vc
        _ = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.update), userInfo: nil, repeats: true);
    }
    
    static func itemSelected(selectedItemID: Int) {
        selectedItemIDs.append(selectedItemID)
        NSLog("Item in der Logic Selected: \(selectedItemIDs.count)")
        //NSLog("Item in der Logic Selected: " + String(selectedItemID))
    }
}
