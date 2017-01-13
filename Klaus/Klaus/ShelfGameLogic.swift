//
//  ShelfGameLogic.swift
//  Klaus
//
//  Created by Oliver Pieper on 13.01.17.
//  Copyright © 2017 Nimm Swag. All rights reserved.
//

import Foundation

class ShelfGameLogic {
    
    var shelfGameVC: ShelfGameViewController
    var items = [DropItemModel]()
    var currentItem: DropItemModel!
    
    init(vc: ShelfGameViewController) {
        self.shelfGameVC = vc
        
        _ = Timer.scheduledTimer(timeInterval: 1.3, target: self, selector: #selector(self.update), userInfo: nil, repeats: true);
    }
    
    @objc func update() {
        currentItem = DropItemModel()
        items.append(currentItem)
        shelfGameVC.view.addSubview(currentItem)
    }
}
