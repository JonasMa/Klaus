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
    let yPosition: Int = 90
    let frameWidth: Int = 60
    let frameHeight: Int = 60
    let framesPerSecond: Int = 30
    var speed: CGFloat = 5
    var groundCollision: CGFloat!
    
    var gameLogic: ShelfGameLogic
    var displayLink = CADisplayLink()
    var vc: ShelfGameViewController!
    
    var timer = Timer.init()
    
    init(logic: ShelfGameLogic, viewController: ShelfGameViewController, xPos: Int, speed: Double) {
        
        self.gameLogic = logic
        self.vc = viewController
        self.xPosition = xPos
        self.speed = CGFloat(Int(arc4random_uniform(4) + 3))
        
        super.init(frame: CGRect(origin: CGPoint(x: xPosition, y: yPosition), size: CGSize(width: frameWidth, height: frameHeight)))
        
        groundCollision = UIScreen.main.bounds.height * 0.9
        
        //Defining as UIImageView and assigning graphic
        self.image = UIImage(named: "porzelan")
        self.isUserInteractionEnabled = true
        
        //Animation Loop initialization
        timer = Timer.scheduledTimer(timeInterval: speed, target: self, selector: #selector(self.startAnimation), userInfo: nil, repeats: false);
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
    
    func startAnimation() {
        self.vc.view.addSubview(self)
        displayLink = CADisplayLink(target: self, selector: #selector(self.handleDisplayLink))
        displayLink.preferredFramesPerSecond = framesPerSecond
        displayLink.add(to: RunLoop.current, forMode: RunLoopMode.defaultRunLoopMode)
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
