//
//  ShelfGameViewController.swift
//  Klaus
//
//  Created by Oliver Pieper on 11.01.17.
//  Copyright © 2017 Nimm Swag. All rights reserved.
//

import UIKit

class ShelfGameViewController: UIViewController {
    
    let gameID = 2
    
    var logic: ShelfGameLogic!
    var gameScore: Double = 0
    
    override func viewDidLoad() {
        logic = ShelfGameLogic(vc: self)
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: false)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func onItemTouchedFloor(score: Double) {
        let vc = ResultViewController(result: score, gameID: gameID)
        navigationController?.pushViewController(vc, animated: true)
    }
}
