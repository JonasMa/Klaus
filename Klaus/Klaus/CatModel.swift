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
    
    init(initialXPos: Int) {
        self.xPos = initialXPos
        super.init(frame: CGRect(origin: CGPoint(x: xPos, y: yPos), size: CGSize(width: frameWidth, height: frameHeight)))
        
        self.image = UIImage(named: "katzeGut")
        self.isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func animateCat(xPosition: Int) {
        UIView.animate(withDuration: 0.2, delay: 0, options: [.autoreverse, .repeat, .curveEaseIn, .allowUserInteraction], animations: {
            self.frame = CGRect(x: xPosition, y: self.yPos, width: self.frameWidth, height: self.frameHeight)
            }, completion: nil)
    }
    
}
