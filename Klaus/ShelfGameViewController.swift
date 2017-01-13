//
//  ShelfGameViewController.swift
//  Klaus
//
//  Created by Oliver Pieper on 11.01.17.
//  Copyright © 2017 Nimm Swag. All rights reserved.
//

import UIKit

class ShelfGameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
                
        let item = DropItemModel()
        let item2 = DropItemModel()
        let item3 = DropItemModel()
        self.view.addSubview(item)
        self.view.addSubview(item2)
        self.view.addSubview(item3)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
     func onItemTouchedFloor() {
        NSLog("Game Over")
    }
    
}
