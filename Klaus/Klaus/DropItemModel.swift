//
//  DropItemModel.swift
//  Klaus
//
//  Created by Oliver Pieper on 11.01.17.
//  Copyright © 2017 Nimm Swag. All rights reserved.
//

import Foundation
import UIKit

class DropItemModel: UIImageView {
    
    var itemStopped = false
    
    init() {
        super.init(frame: CGRect(origin: CGPoint(x: 120, y: 0), size: CGSize(width: 50, height: 50)))
        
        self.image = UIImage(named: "porzelan")
        
        UIView.animate(withDuration: 3.0, animations: {
            self.frame = CGRect(x: 120, y: 400, width: 50, height: 50)
            }, completion: { animationFinished in
                if (!self.itemStopped){
                    self.removeFromSuperview()
                    ShelfGameViewController.onItemTouchedFloor()
                }
        })
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func didTap(tapGR: UITapGestureRecognizer) {
        itemStopped = true
        let layer = self.layer.presentation()! as CALayer
        let frame = layer.frame
        self.layer.removeAllAnimations()
        self.frame = frame
    }
}
