//
//  ShelfGameViewController.swift
//  Klaus
//
//  Created by Oliver Pieper on 11.01.17.
//  Copyright © 2017 Nimm Swag. All rights reserved.
//

import UIKit

class ShelfGameViewController: UIViewController {
    
    var logic = ShelfGameLogic()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logic.setVC(vc: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func onItemTouchedFloor() {
        ShelfGameLogic.killGame()
    }
}
