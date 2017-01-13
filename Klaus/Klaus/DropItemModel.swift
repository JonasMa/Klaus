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
    
    let xPosition: Int = 120
    let yPosition: Int = 30
    let frameWidth: Int = 60
    let frameHeight: Int = 60
    let framesPerSecond: Int = 40
    let speed: CGFloat = 4
    let groundCollision: CGFloat = 500
    
    var displayLink = CADisplayLink()
    var tapGesture = UITapGestureRecognizer()
    
    init() {
        super.init(frame: CGRect(origin: CGPoint(x: xPosition, y: yPosition), size: CGSize(width: frameWidth, height: frameHeight)))
        
        //Defining as UIImageView and assigning graphic
        self.image = UIImage(named: "porzelan")
        self.isUserInteractionEnabled = true
        
        //Animation Loop initialization
        displayLink = CADisplayLink(target: self, selector: #selector(self.handleDisplayLink))
        displayLink.preferredFramesPerSecond = framesPerSecond
        displayLink.add(to: RunLoop.current, forMode: RunLoopMode.defaultRunLoopMode)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        NSLog("touch began")
        displayLink.invalidate()
        //self.removeFromSuperview()
    }
    
    func handleDisplayLink() {
        var viewFrame = self.frame
        viewFrame.origin.y += speed
        self.frame = viewFrame
        if self.frame.origin.y >= groundCollision {
            displayLink.invalidate()
            ShelfGameViewController.onItemTouchedFloor()
        }
    }
    
    
}
