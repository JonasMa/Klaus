

import Foundation
import UIKit
import AudioToolbox

class CableModel: UIImageView {
    
    var model: SeitenschneiderModel!
    
    let screenSize:CGRect!
    let screenWidth:CGFloat!
    let screenHeight:CGFloat!
    
    let cableSize:CGSize!
    var animationEndPoint:[CGFloat]!
    var randomAnimationEndPosition:CGFloat!
    var cablePosition:[CGPoint]!
    var randomCablePosition: CGPoint!
    var cableSpeed:Double!
    let cableSpeedFast:Double!
    
    init(color: UIColor, model: SeitenschneiderModel) {
        self.model = model
        
        self.screenSize = UIScreen.main.bounds
        self.screenWidth = screenSize.width
        self.screenHeight = screenSize.height
        
        let randomFactor = Int(arc4random_uniform(2))
        self.animationEndPoint = [self.screenWidth, 0]
        self.randomAnimationEndPosition = animationEndPoint[randomFactor]
        self.cablePosition = [CGPoint(x: 0.0, y: 0.0), CGPoint(x: screenWidth, y: 0.0)]
        self.randomCablePosition = cablePosition[randomFactor]

        let randomSpeed = arc4random_uniform(20) + 10
        self.cableSpeed = Double(randomSpeed) * 0.1
        self.cableSpeedFast = 2.0
        
        self.cableSize = CGSize(width: 20.0, height: screenHeight)
        
        super.init(frame: CGRect(origin: randomCablePosition, size: cableSize))
        self.backgroundColor = color
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 2.0
        
        
        animateCables()
    }
    
    func animateCables(){
        let randomDelay = Double(arc4random_uniform(15)) * 0.1
        UIView.animate(withDuration: cableSpeed, delay: TimeInterval(randomDelay), options: [.autoreverse, .repeat, .curveEaseIn, .allowUserInteraction], animations: {
            self.frame = CGRect(x: self.randomAnimationEndPosition, y: 0, width:self.cableSize.width, height: self.screenHeight)
        }, completion: nil)
    }
    
    func getCableLocation() -> CGFloat {
        let currentCableLocation = self.layer.presentation()?.frame
        let cableX = currentCableLocation?.origin.x
        return cableX!
    }
    
    func checkTouch(touchLocation: CGPoint) -> Bool{
        let currentCableLocation = self.layer.presentation()?.frame
        let cableXCoordinate = currentCableLocation?.origin.x
        
        let touchYCoordinate = touchLocation.y
        let touchXCoordinate = touchLocation.x

        if Double(touchXCoordinate + 15.0) > Double(cableXCoordinate!) && Double(touchXCoordinate - 15.0) < Double(cableXCoordinate!) {
            if self.backgroundColor != UIColor.blue{
                AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                model.decreaseScore()
            } else {
                model.increaseScore()
            }
            
            // Stop animation
            self.layer.presentation()?.removeAllAnimations()
            self.frame = CGRect(x: cableXCoordinate!, y: touchYCoordinate, width:self.cableSize.width, height: self.screenHeight/2)
            
            let cableHalf = UIView()
            cableHalf.backgroundColor = self.backgroundColor
            cableHalf.frame = CGRect(x: cableXCoordinate!, y: 0.0, width:self.cableSize.width, height: self.screenHeight-(screenHeight - touchLocation.y))
            model.addCableHalf(cableHalf: cableHalf)

            // Start slide away animation
            UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveEaseOut, animations: {
                self.frame = CGRect(x: cableXCoordinate!, y: self.screenHeight, width:self.cableSize.width, height: self.screenHeight/2)
                cableHalf.frame = CGRect(x: cableXCoordinate!, y: -self.screenHeight, width:self.cableSize.width, height: self.screenHeight/2)
            }, completion: nil)
            
           
            delay(delay: 1.0){self.removeFromSuperview(); cableHalf.removeFromSuperview()}
            return true
        } else {
            // nothing touched
            return false
        }
    }
    
    func delay(delay:Double, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { closure()}
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
