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
                
        let shapeView = DropItemModel()
        self.view.addSubview(shapeView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    static func onItemTouchedFloor() {
        NSLog("Game Over")
    }
    
}
