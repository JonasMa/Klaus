

import Foundation
import UIKit

class SeitenschneiderModel {
    
    var seitenSchneiderViewController: SeitenschneiderViewController!
    var cableModelObject: CableModel!
    var allCables: [CableModel]!
        
    let targetCableColor = UIColor.blue
    let maxNumCablesInGame = 12
    var score = 0
    var strikes = 0
    let randomColor = [UIColor.red, UIColor.green]
    
    init(viewController: SeitenschneiderViewController) {
        self.score = 0
        self.seitenSchneiderViewController = viewController
        self.allCables = [CableModel]()
        

        
        // Add start cables
        addCables(isMainTargetColor: true, numOfCables: 4)
        addCables(isMainTargetColor: false, numOfCables: 6)
    }
    
    func getRandomCableColor() -> UIColor {
        return randomColor[Int(arc4random_uniform(UInt32(randomColor.count)))]
    }
    
    func addCables(isMainTargetColor: Bool, numOfCables: Int) {
        for _ in 0..<numOfCables {
            if isMainTargetColor {
                cableModelObject = CableModel(color: targetCableColor, model: self)
            } else {
                cableModelObject = CableModel(color: getRandomCableColor(), model: self)
            }
            allCables.append(cableModelObject)
            seitenSchneiderViewController.view.insertSubview(cableModelObject, at: 0)
        }
    }
    
    func addCableHalf(cableHalf: UIView) {
        seitenSchneiderViewController.view.insertSubview(cableHalf, at: 0)
    }
    
    func checkCableTouch(touchLoc: CGPoint) {
        for cable in allCables{
            if cable.checkTouch(touchLocation: touchLoc){
                let index = allCables.index(of: cable)
                if cable.backgroundColor == targetCableColor {
                    addCables(isMainTargetColor: true, numOfCables: 1)
                } else {
                    addCables(isMainTargetColor: false, numOfCables: 1)
                }
                allCables.remove(at: index!)
            }
        }
    }
    
//    func addNewCablesInGame() {
////        let numCablesWhichCanBeAdded = maxNumCablesInGame - allCables.count
////        if numCablesWhichCanBeAdded > 3 {
////            addCables(isMainTargetColor: true, numOfCables: 1)
////            addCables(isMainTargetColor: false, numOfCables: Int(arc4random_uniform(UInt32(2))))
////        } else {
////            addCables(isMainTargetColor: true, numOfCables: Int(arc4random_uniform(UInt32(numCablesWhichCanBeAdded))))
////        }
//    }
//    
    func increaseScore() {
        score += 1
    }
    
    func decreaseScore() {
        seitenSchneiderViewController.destroyZange()
        strikes += 1
        if strikes >= 3 {
            gameEnded()
        }
    }
    
    func gameEnded(){
        seitenSchneiderViewController.startResultViewController()
    }
    
}
