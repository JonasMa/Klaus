//
//  CatModel.swift
//  Klaus
//
//  Created by Oliver Pieper on 31.01.17.
//  Copyright © 2017 Nimm Swag. All rights reserved.
//

import Foundation
import UIKit

class CatModel: UIImageView {
    
    let frameWidth: Int = 100
    let frameHeight: Int = 70
    let yPos: Int = 80
    var xPos: Int!
    
    init() {
        self.xPos = Int(arc4random_uniform(UInt32(UIScreen.main.bounds.width-50)-5) + 5)
        super.init(frame: CGRect(origin: CGPoint(x: xPos, y: yPos), size: CGSize(width: frameWidth, height: frameHeight)))
        
        self.image = UIImage(named: "katzeGut")
        self.alpha = 0.1
        UIView.animate(withDuration: 0.5, delay: 0.5, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.alpha = 1.0
            }, completion: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func animateCat(speed: Double) {
        self.xPos = Int(arc4random_uniform(UInt32(UIScreen.main.bounds.width-50)-5) + 5)
        UIView.animate(withDuration: speed, delay: 0, options: [.autoreverse, .repeat, .curveEaseInOut, .allowUserInteraction], animations: {
            self.frame = CGRect(x: self.xPos, y: self.yPos, width: self.frameWidth, height: self.frameHeight)
            }, completion: nil)
    }
    
    func getXPos() -> Int{
        return xPos
    }
    
}
