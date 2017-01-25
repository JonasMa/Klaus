

import UIKit

class SeitenschneiderViewController: UIViewController {

    
    var seitenSchneiderModel: SeitenschneiderModel!
    
    let screenSize: CGRect = UIScreen.main.bounds
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    
    
    let cable = UIView()
   // var cableSpeed:CGFloat = 0.0
//    var timer = Timer.init()
    
   // var direction = 10.0
    
    override func viewDidLoad() {
        screenHeight = screenSize.height
        screenWidth = screenSize.width
        
        super.viewDidLoad()
        
        //createCables(color: UIColor.blue)
        // Do any additional setup after loading the view.
        
        seitenSchneiderModel = SeitenschneiderModel(viewController: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createCables(color: UIColor) {
//        cableSpeed = CGFloat(arc4random_uniform(UInt32(5.0)))
        
//        let randomPosition = CGFloat(arc4random_uniform(UInt32(screenWidth-50.0)-UInt32(cableSize.width)) + UInt32(cableSize.width))
        
//        let cableSize = CGSize(width: 20.0, height: screenHeight)
//        let cablePosition = CGPoint(x: 0.0, y: 0.0)
//        cable.backgroundColor = color
//        
//        cable.frame = CGRect(origin: cablePosition, size: cableSize)
        
//        let tapOnCable = UITapGestureRecognizer(target:self, action: #selector(cableTouched))
//        cable.addGestureRecognizer(tapOnCable)
        
//        self.view.addSubview(cable)
        
        
        //timer = Timer.scheduledTimer(timeInterval: duration, target: self, selector: #selector(animateCable), userInfo: nil, repeats: true)
        
        //let randomDuration = Double(arc4random_uniform(UInt32(2.0)))
        
//        UIView.animate(withDuration: 2.0, delay: 0.0, options: [.autoreverse, .repeat, .curveEaseIn, .allowUserInteraction], animations: {
//            self.cable.frame = CGRect(x: self.screenWidth, y: 0, width:cableSize.width, height: self.screenHeight)
//        }, completion: nil)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        let currentCableLocation = cable.layer.presentation()?.frame
//        let cableXCoordinate = currentCableLocation?.origin.x
//        //print ("height: n\(currentCableLocation?.origin.x)")
//        
        let touch = touches.first! as UITouch
        let touchLocation = touch.location(in: self.view)
//
//        let touchXCoordinate = touchLocation.x
//        
//        if Double(touchXCoordinate + 10.0) > Double(cableXCoordinate!) && Double(touchXCoordinate - 10.00) < Double(cableXCoordinate!) {
//         print("touched")
//         // stop animation 
//            
//         cable.removeFromSuperview()
//         startResultViewController()
//        }
//        
//       // if currentCableLocation?.origin.x
//        
        seitenSchneiderModel.checkCableTouch(touchLoc:touchLocation)
        
    }
    
//    func animateCable() {
//        let yPosition = cable.frame.origin.y
//        var xPosition = cable.frame.origin.x
//        
//        if (xPosition + 1) > screenWidth{
//            xPosition = cable.frame.origin.x - 1
//            direction = -1
//        } else if (xPosition - 1) < 0 {
//            xPosition = cable.frame.origin.x + 1
//            direction = 1
//        } else {
//            xPosition = xPosition + CGFloat(direction)
//        }
//        
//        cable.frame = CGRect(x: xPosition, y: yPosition, width: cable.frame.size.width, height: cable.frame.size.height)
//    }
    
//    func cableTouched(sender: UITapGestureRecognizer? = nil) {
//        print ("cavletouched")
//        cable.removeFromSuperview()
//    }
    
    
//    func onGameFinished(score: Double,duration: Int) {
//        let viewController = ResultViewController(result: score)
//        navigationController?.pushViewController(viewController, animated: true)
//    }
    
    func startResultViewController() {
        let score = seitenSchneiderModel.score
        let vc = ResultViewController(result: Double(score))
        navigationController?.pushViewController(vc, animated: true)
    }

}
