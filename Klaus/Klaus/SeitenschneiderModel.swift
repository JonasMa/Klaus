

import Foundation
import UIKit

class SeitenschneiderModel {
    
    var seitenSchneiderViewController: SeitenschneiderViewController!
    var cableModelObject: CableModel!
    var allCables: [CableModel]!
    
    let timer: StopwatchTimer!
    
    let targetCableColor = UIColor.blue
    let maxNumCablesInGame = 12
    var score = 0
    var strikes = 0
    let randomColor = [UIColor.red, UIColor.green]
    
    init(viewController: SeitenschneiderViewController) {
        self.score = 0
        self.seitenSchneiderViewController = viewController
        self.allCables = [CableModel]()
        
        self.timer = StopwatchTimer.init(needGameUpdate: true, maxDuration: 15)
        timer.startTimer()
        NotificationCenter.default.addObserver(forName: NotificationCenterKeys.timerMaxDurationReached, object: nil, queue: nil, using: gameEnded)
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
//            seitenSchneiderViewController.view.addSubview(cableModelObject)
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
                addNewCablesInGame()
                allCables.remove(at: index!)
            }
        }
    }
    
    func addNewCablesInGame() {
        let numCablesWhichCanBeAdded = maxNumCablesInGame - allCables.count
        if numCablesWhichCanBeAdded > 3 {
            addCables(isMainTargetColor: true, numOfCables: Int(arc4random_uniform(UInt32(3))))
        } else {
            addCables(isMainTargetColor: true, numOfCables: Int(arc4random_uniform(UInt32(numCablesWhichCanBeAdded))))
        }
    }
    
    func increaseScore() {
        score += 1
    }
    
    func decreaseScore() {
        strikes += 1
        if score > 0 {
           score -= 1
        }
        if strikes >= 3 {
            timer.stopTimer()
            seitenSchneiderViewController.startResultViewController()
        }
    }
    
    func gameEnded(notification:Notification){
        timer.stopTimer()
        seitenSchneiderViewController.startResultViewController()
        // weiterverschicken: timer.duration
    }
    
}
