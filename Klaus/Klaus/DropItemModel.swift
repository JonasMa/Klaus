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
    
    var xPosition: Int = 120
    let yPosition: Int = 30
    let frameWidth: Int = 60
    let frameHeight: Int = 60
    let framesPerSecond: Int = 30
    var speed: CGFloat = 5
    let groundCollision: CGFloat = 500
    
    var displayLink = CADisplayLink()
    var tapGesture = UITapGestureRecognizer()
    var shelfGameVC = ShelfGameViewController()
    
    init() {
        
        self.xPosition = Int(arc4random_uniform(350) + 10)
        self.speed = CGFloat(Int(arc4random_uniform(5) + 3))
        
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
        displayLink.isPaused = true
        //self.removeFromSuperview()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        displayLink.isPaused = false
    }
    
    func handleDisplayLink() {
        var viewFrame = self.frame
        viewFrame.origin.y += speed
        self.frame = viewFrame
        if self.frame.origin.y >= groundCollision {
            displayLink.invalidate()
            shelfGameVC.onItemTouchedFloor()
        }
    }
    
    
}
