//
//  DropItemModel.swift
//  Klaus
//
//  Created by Oliver Pieper on 11.01.17.
//  Copyright © 2017 Nimm Swag. All rights reserved.
//

import Foundation
import UIKit
import AudioToolbox

class DropItemModel: UIImageView {
    
    var paused: Bool = false
    var gameNotOverYet: Bool = true
    
    var xPosition: Int = 120
    let yPosition: Int = 60
    let frameWidth: Int = 60
    let frameHeight: Int = 60
    let framesPerSecond: Int = 30
    var speed: CGFloat = 5
    var groundCollision: CGFloat!
    
    var gameLogic: ShelfGameLogic
    var displayLink = CADisplayLink()
    var tapGesture = UITapGestureRecognizer()
    var shelfGameVC = ShelfGameViewController()
    
    init(logic: ShelfGameLogic) {
        
        self.gameLogic = logic
        self.xPosition = Int(arc4random_uniform(UInt32(UIScreen.main.bounds.width-50)-5) + 5)
        self.speed = CGFloat(Int(arc4random_uniform(4) + 3))
        
        super.init(frame: CGRect(origin: CGPoint(x: xPosition, y: yPosition), size: CGSize(width: frameWidth, height: frameHeight)))
        
        groundCollision = UIScreen.main.bounds.height * 0.9
        
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
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        displayLink.isPaused = true
        paused = true
        gameLogic.increaseSelectedItemCount()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        displayLink.isPaused = false
        paused = false
        gameLogic.decreaseSelectedItemCount()
    }
    
    func killItem () {
        gameNotOverYet = false
        self.removeFromSuperview()
    }
    
    func isPaused() -> Bool {
        return paused
    }
    
    func getXLocation() -> Int {
        return xPosition
    }
    
    func handleDisplayLink() {
        var viewFrame = self.frame
        viewFrame.origin.y += speed
        self.frame = viewFrame
        if self.frame.origin.y >= groundCollision {
            displayLink.invalidate()
            if gameNotOverYet {
                gameLogic.gameOverYet = true
            }

        }
    }
}
