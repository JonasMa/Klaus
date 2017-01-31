//
//  AxeModel.swift
//  Klaus
//
//  Created by Oliver Pieper on 31.01.17.
//  Copyright © 2017 Nimm Swag. All rights reserved.
//

import Foundation
import UIKit

class AxeModel: UIImageView {
    
    let xPosition = UIScreen.main.bounds.height * 0.10
    let yPosition = UIScreen.main.bounds.height * 0.3
    let frameWidth = 180
    let frameHeight = 270
    
    
    init() {
        super.init(frame: CGRect(origin: CGPoint(x: xPosition, y: yPosition), size: CGSize(width: frameWidth, height: frameHeight)))
        self.image = UIImage(named: "Axt")
        animateAxe()
        /*self.alpha = 0.1
        UIView.animate(withDuration: 0.1, delay: 0.5, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.alpha = 1.0
            }, completion: nil)*/
    }
    
    func animateAxe() {
        UIView.animate(withDuration: 0.1, delay: 0, options: [.autoreverse, .repeat, .curveEaseInOut], animations:{
            self.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI_4))
            })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
