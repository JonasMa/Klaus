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
    var gameScore: Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: false)
        logic.setVC(vc: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func onItemTouchedFloor(score: Double) {
        let vc = ResultViewController(result: score)
        navigationController?.pushViewController(vc, animated: true)
    }
}
