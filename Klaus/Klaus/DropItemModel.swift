//
//  DropItemModel.swift
//  Klaus
//
//  Created by Oliver Pieper on 11.01.17.
//  Copyright © 2017 Nimm Swag. All rights reserved.
//

import Foundation
import UIKit

class DropItemModel: UIView {
    
    
    init() {
        super.init(frame: CGRect(origin: CGPoint(x: 120, y: 0), size: CGSize(width: 50, height: 50)))
        self.backgroundColor = UIColor.blue
        
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(self.didTap(tapGR:)))
        addGestureRecognizer(tapGR)
        
        UIView.animate(withDuration: 3.0, animations: {
            self.frame = CGRect(x: 120, y: 400, width: 50, height: 50)
        })
        

    }
    
    // We need to implement init(coder) to avoid compilation errors
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
    
    func didTap(tapGR: UITapGestureRecognizer) {
        
        self.removeFromSuperview()
        print("touch")
        NSLog("touch")
    }

}
