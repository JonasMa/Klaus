

import UIKit

class SeitenschneiderViewController: UIViewController {

    
    var seitenSchneiderModel: SeitenschneiderModel!
    
    let screenSize: CGRect = UIScreen.main.bounds
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    
    
    let cable = UIView()
    override func viewDidLoad() {
        screenHeight = screenSize.height
        screenWidth = screenSize.width
        
    super.viewDidLoad()
        seitenSchneiderModel = SeitenschneiderModel(viewController: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
      
        let touch = touches.first! as UITouch
        let touchLocation = touch.location(in: self.view)

        seitenSchneiderModel.checkCableTouch(touchLoc:touchLocation)
    }

    func startResultViewController() {
        let score = seitenSchneiderModel.score
        let vc = ResultViewController(result: Double(score))
        navigationController?.pushViewController(vc, animated: true)
    }

}
