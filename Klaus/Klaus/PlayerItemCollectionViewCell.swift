//
//  PlayerItemCollectionViewCell.swift
//  Klaus
//
//  Created by Alex Knittel on 28.12.16.
//  Copyright © 2016 Nimm Swag. All rights reserved.
//

import UIKit

class PlayerItemCollectionViewCell: ItemCollectionViewCell {
    
    func highlight(){
        UIView.animate(withDuration: 1, delay: 0.0, options:[UIViewAnimationOptions.repeat, UIViewAnimationOptions.autoreverse], animations: {
            self.backgroundColor = UIColor.green.withAlphaComponent(0.5)
            self.backgroundColor = nil;
        }, completion: nil)
    }
    
    func unhighlight(){
        self.backgroundColor = nil;
    }
    
}
