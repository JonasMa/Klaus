

import UIKit

class SeitenschneiderViewController: UIViewController {
    
    let gameID = 3
    var seitenSchneiderModel: SeitenschneiderModel!
    
    let screenSize: CGRect = UIScreen.main.bounds
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    
    var seitenschneiderGradient: CAGradientLayer!
    
    override func viewDidLoad() {
        screenHeight = screenSize.height
        screenWidth = screenSize.width
        
    super.viewDidLoad()
        seitenSchneiderModel = SeitenschneiderModel(viewController: self)
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        initializeUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func initializeUI() {
        //self.view.backGroundColor = Style.bg
        
        // Initialize Gradient
        seitenschneiderGradient = CAGradientLayer()
        seitenschneiderGradient.colors = Style.gradientColorsSeitenschneider
        seitenschneiderGradient.locations = Style.gradientLocationsSeitenschneider as [NSNumber]?
        seitenschneiderGradient.frame = screenSize
        
        self.view.layer.addSublayer(seitenschneiderGradient)
        
        // 3 Bilder von ner Zange reinmachen
//        for _ in 0 ..<3 {
//            
//        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first! as UITouch
        let touchLocation = touch.location(in: self.view)
        seitenSchneiderModel.checkCableTouch(touchLoc:touchLocation)
    }

    func startResultViewController() {
        let score = seitenSchneiderModel.score
        let vc = ResultViewController(result: Double(score), gameID: gameID)
        navigationController?.pushViewController(vc, animated: true)
    }

}
