//
//  CountdownModel.swift
//  Klaus
//
//  Created by Oliver Pieper on 30.12.16.
//  Copyright © 2016 Nimm Swag. All rights reserved.
//

import Foundation
import UIKit

class CountdownModel {
    
    var gameTimer: Timer!
    var count = 10
    var viewController: GameViewController
    
    
    init(vc: GameViewController) {
        self.viewController = vc
        gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(update), userInfo: nil, repeats: true)
    }
    
    @objc func update() {
        if(count > 0) {
            count -= 1
            viewController.updateLabel(countr: count)
        }else if (count == 0) {
            gameTimer.invalidate()
            viewController.startResultView()
        }
    }
}
