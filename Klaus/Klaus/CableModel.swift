

import Foundation
import UIKit
import AudioToolbox

class CableModel: UIImageView {
    
    var model: SeitenschneiderModel!
    
    let screenSize:CGRect!
    let screenWidth:CGFloat!
    let screenHeight:CGFloat!
    
    let cableSize:CGSize!
    let cablePosition = CGPoint(x: 0.0, y: 0.0)
    let cableSpeed:Double
    
    init(color: UIColor, model: SeitenschneiderModel) {
        self.model = model
        
        self.screenSize = UIScreen.main.bounds
        self.screenWidth = screenSize.width
        self.screenHeight = screenSize.height
        
        let randomSpeed = arc4random_uniform(20) + 10
        self.cableSpeed = Double(randomSpeed) * 0.1
        print("speed")
        print(cableSpeed)
        
        self.cableSize = CGSize(width: 20.0, height: screenHeight)
        
        super.init(frame: CGRect(origin: cablePosition, size: cableSize))
        self.backgroundColor = color
        
        animateCables()
    }
    
    func animateCables(){
        UIView.animate(withDuration: cableSpeed, delay: 0.0, options: [.autoreverse, .repeat, .curveEaseIn, .allowUserInteraction], animations: {
            self.frame = CGRect(x: self.screenWidth, y: 0, width:self.cableSize.width, height: self.screenHeight)
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

        let touchXCoordinate = touchLocation.x

        if Double(touchXCoordinate + 10.0) > Double(cableXCoordinate!) && Double(touchXCoordinate - 10.0) < Double(cableXCoordinate!) {
            if self.backgroundColor != UIColor.blue{
                AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                model.decreaseScore()
            } else {
                model.increaseScore()
            }
            print("touchedred")
            // stop animation & cut in half
           // self.stopAnimating()
            self.removeFromSuperview()
            model.checkAllCablesDeleted()
            return true
        } else {
            return false
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
