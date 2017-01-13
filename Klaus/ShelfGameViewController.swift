//
//  ShelfGameViewController.swift
//  Klaus
//
//  Created by Oliver Pieper on 11.01.17.
//  Copyright © 2017 Nimm Swag. All rights reserved.
//

import UIKit

class ShelfGameViewController: UIViewController {
    
    var logic: ShelfGameLogic!
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        logic = ShelfGameLogic(vc: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
     func onItemTouchedFloor() {
        NSLog("Game Over")
    }
    
}
