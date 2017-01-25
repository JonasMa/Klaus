

import Foundation
import UIKit

class SeitenschneiderModel {
    
    var seitenSchneiderViewController: SeitenschneiderViewController!
    var cableModelObject: CableModel!
    var allCables: [CableModel]!
    
    let timer: StopwatchTimer!
    
    var score = 0
    let randomColor = [UIColor.red, UIColor.brown, UIColor.cyan]
    
    init(viewController: SeitenschneiderViewController) {
        self.score = 0
        self.seitenSchneiderViewController = viewController
        self.allCables = [CableModel]()
        
        self.timer = StopwatchTimer()
        timer.startTimer()
        
        for _ in 0..<4 {
            addCables(color: UIColor.blue)
            addCables(color: randomColor[Int(arc4random_uniform(UInt32(randomColor.count)))])
        }
    }
    
    func addCables(color: UIColor) {
        cableModelObject = CableModel(color: color, model: self)
        allCables.append(cableModelObject)
        seitenSchneiderViewController.view.addSubview(cableModelObject)
    }
    
    func checkCableTouch(touchLoc: CGPoint) {
        checkAllCablesDeleted()
        for cable in allCables{
            if cable.checkTouch(touchLocation: touchLoc){
                let index = allCables.index(of: cable)
                allCables.remove(at: index!)
            }
        }
        
    }
    
    func checkAllCablesDeleted() {
        print("checkgameended")
        var blueCablesLeft = 0
        for cable in allCables {
            if cable.backgroundColor == UIColor.blue {
                blueCablesLeft += 1
            }
        }
        if allCables.count == 0 {
            gameEnded()
        } else if blueCablesLeft == 0 {
            gameEnded()
        }
    }
    
    func increaseScore() {
        score += 1
    }
    
    func decreaseScore() {
        score -= 1
    }
    
    func gameEnded(){
        print("gameEnded")
        timer.stopTimer()
        seitenSchneiderViewController.startResultViewController()
        // weiterverschicken: timer.duration
    }
    
}
