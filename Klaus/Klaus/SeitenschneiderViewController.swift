

// 

import UIKit

class SeitenschneiderViewController: UIViewController {
    
    let gameID = 3
    var seitenSchneiderModel: SeitenschneiderModel!
    var timer: StopwatchTimer!
    
    let screenSize: CGRect = UIScreen.main.bounds
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    
    var seitenschneiderGradient: CAGradientLayer!
    
    var timeDisplay: UIImageView!
    
    var zangeOne: UIImageView!
    var zangeTwo: UIImageView!
    var zangeThree: UIImageView!
    
    override func viewDidLoad() {
        screenHeight = screenSize.height
        screenWidth = screenSize.width
        
    super.viewDidLoad()
        seitenSchneiderModel = SeitenschneiderModel(viewController: self)
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        self.timer = StopwatchTimer.init(needGameUpdate: true, maxDuration: 30)
        timer.startTimer()
        NotificationCenter.default.addObserver(forName: NotificationCenterKeys.timerMaxDurationReached, object: nil, queue: nil, using: timeLine)
        
        initializeUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func initializeUI() {
        //self.view.backGroundColor = Style.bg
        
        seitenschneiderGradient = CAGradientLayer()
        seitenschneiderGradient.colors = Style.gradientColorsSeitenschneider
        seitenschneiderGradient.locations = Style.gradientLocationsSeitenschneider as [NSNumber]?
        seitenschneiderGradient.frame = screenSize
        
        self.view.layer.addSublayer(seitenschneiderGradient)
        
        zangeOne = getSeitenschneiderImage()
        setSeitenschneiderImage(seitenschneiderImage: zangeOne, position: CGFloat(-screenWidth / 5))
        
        zangeTwo = getSeitenschneiderImage()
        setSeitenschneiderImage(seitenschneiderImage: zangeTwo, position: 0)
        
        zangeThree = getSeitenschneiderImage()
        setSeitenschneiderImage(seitenschneiderImage: zangeThree, position: CGFloat(screenWidth / 5))
    }
    
    func destroyZange() {
        let images = [zangeOne, zangeTwo, zangeThree]
        images[(seitenSchneiderModel.strikes)]?.image = UIImage(named: "axe")
    }
    
    func timeLine(notification: Notification){
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first! as UITouch
        let touchLocation = touch.location(in: self.view)
        seitenSchneiderModel.checkCableTouch(touchLoc:touchLocation)
    }

    func startResultViewController() {
        timer.stopTimer()
        self.view.isUserInteractionEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let score = self.seitenSchneiderModel.score
            let vc = ResultViewController(result: Double(score), gameID: self.gameID)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension UIViewController {
    
    func getSeitenschneiderImage() ->UIImageView{
        let seitenschneiderImage = UIImageView()
        seitenschneiderImage.image = UIImage(named: "zange")
        seitenschneiderImage.translatesAutoresizingMaskIntoConstraints = false
        return seitenschneiderImage
    }
    
    func setSeitenschneiderImage(seitenschneiderImage: UIImageView, position: CGFloat){
        self.view.addSubview(seitenschneiderImage)
        self.view.bringSubview(toFront: seitenschneiderImage)
        seitenschneiderImage.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.2).isActive = true
        seitenschneiderImage.heightAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.2).isActive = true
        seitenschneiderImage.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: position).isActive = true
        seitenschneiderImage.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -225).isActive = true
    }
}
