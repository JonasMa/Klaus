
import UIKit

class SeitenschneiderViewController: UIViewController {
    
    let gameID = 3
    var seitenSchneiderModel: SeitenschneiderModel!
    
    let screenSize: CGRect = UIScreen.main.bounds
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    
    var seitenschneiderGradient: CAGradientLayer!
    
    var timeDisplay: UIImageView!
    var timeDisplaySize: CGSize!
    var timeDisplayPosition: CGPoint!
    var lastDisplayFrame: CGRect!
    
    var cableCuttedDisplay: UILabel!
    
    var zangeOne: UIImageView!
    var zangeTwo: UIImageView!
    var zangeThree: UIImageView!
    
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.black
        screenHeight = screenSize.height
        screenWidth = screenSize.width
        
    super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: false)
        seitenSchneiderModel = SeitenschneiderModel(viewController: self)
        
        initializeImages()
        initializeScoreLabel()
        initializeTimeline()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func initializeImages() {
        seitenschneiderGradient = CAGradientLayer()
        seitenschneiderGradient.colors = Style.gradientColorsSeitenschneider
        seitenschneiderGradient.locations = Style.gradientLocationsSeitenschneider as [NSNumber]?
        seitenschneiderGradient.frame = screenSize
        self.view.layer.addSublayer(seitenschneiderGradient)
        
        zangeOne = getSeitenschneiderImage()
        setSeitenschneiderImage(seitenschneiderImage: zangeOne, position: CGFloat(-screenWidth/4))
        zangeTwo = getSeitenschneiderImage()
        setSeitenschneiderImage(seitenschneiderImage: zangeTwo, position: 0)
        zangeThree = getSeitenschneiderImage()
        setSeitenschneiderImage(seitenschneiderImage: zangeThree, position: CGFloat(screenWidth/4))
    }
    
    func initializeScoreLabel(){
        cableCuttedDisplay = UILabel(frame: CGRect(x: 100, y: 100, width: screenHeight*0.1, height: screenHeight*0.1))
        cableCuttedDisplay.text = "0"
        cableCuttedDisplay.font = Style.titleTextFontBold
        cableCuttedDisplay.textColor = UIColor.red
        cableCuttedDisplay.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(cableCuttedDisplay)
        self.view.bringSubview(toFront: cableCuttedDisplay)
        cableCuttedDisplay.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.2).isActive = true
        cableCuttedDisplay.heightAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.2).isActive = true
        cableCuttedDisplay.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: CGFloat(screenWidth / 4*2)).isActive = true
        cableCuttedDisplay.centerYAnchor.constraint(equalTo: self.view.topAnchor, constant: CGFloat(screenHeight*0.18)).isActive = true
    }
    
    func initializeTimeline() {
        timeDisplaySize = CGSize(width: screenWidth, height: 20)
        timeDisplayPosition = CGPoint(x: 0, y: screenHeight - timeDisplaySize.height)
        timeDisplay = UIImageView(frame: CGRect(origin: timeDisplayPosition, size: timeDisplaySize))
        timeDisplay.backgroundColor = UIColor.cyan
        timeDisplay.layer.borderWidth = 2
        timeDisplay.layer.borderColor = UIColor.black.cgColor
        self.view.addSubview(timeDisplay)
        self.view.bringSubview(toFront: timeDisplay)
        startAnimatingTimeLine()
    }

    
    func startAnimatingTimeLine() {
        UIView.animate(withDuration: TimeInterval(seitenSchneiderModel.maxGameDuration), delay: 0.0, options: .curveEaseOut, animations: {
            self.timeDisplay.frame = CGRect(x: self.timeDisplayPosition.x, y: self.timeDisplayPosition.y, width: CGFloat(0), height: self.timeDisplaySize.height)
        }, completion: nil)
    }
    
    
    func setNewAnimation(){
        timeDisplay.layer.presentation()?.removeAllAnimations()
        timeDisplay.frame = CGRect(x: self.timeDisplayPosition.x, y: self.timeDisplayPosition.y, width: getNewXCoordinate(), height: self.timeDisplaySize.height)
        self.view.bringSubview(toFront: timeDisplay)
        UIView.animate(withDuration: TimeInterval(seitenSchneiderModel.newDuration), delay: 0.0, options: .curveEaseOut, animations: {
            self.timeDisplay.frame = CGRect(x: self.timeDisplayPosition.x, y: self.timeDisplayPosition.y, width: CGFloat(0), height: self.timeDisplaySize.height)
        }, completion: nil)
    }
    
    func getNewXCoordinate()-> CGFloat{
        var newX: CGFloat = 0.0
        let possibleNewWidth = CGFloat((Int(screenWidth) / seitenSchneiderModel.maxGameDuration) * seitenSchneiderModel.newDuration)
        if possibleNewWidth >= screenWidth {
            newX = screenWidth
        } else {
            newX = possibleNewWidth
        }
        return newX
    }
    
    func destroyZange() {
        let images = [zangeOne, zangeTwo, zangeThree]
        if seitenSchneiderModel.strikes < 3 {
            images[(seitenSchneiderModel.strikes)]?.image = UIImage(named: "zange_kaputt")
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first! as UITouch
        let touchLocation = touch.location(in: self.view)
        seitenSchneiderModel.checkCableTouch(touchLoc:touchLocation)
    }
    

    func startResultViewController() {
        print ("result wird aufgerufen")
        self.view.isUserInteractionEnabled = false
        let score = self.seitenSchneiderModel.score
        let vc = ResultViewController(result: Double(score), gameID: self.gameID)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension UIViewController {
    func getSeitenschneiderImage() ->UIImageView{
        let seitenschneiderImage = UIImageView()
        seitenschneiderImage.image = UIImage(named: "zange_bunt")
        seitenschneiderImage.translatesAutoresizingMaskIntoConstraints = false
        return seitenschneiderImage
    }
    
    func setSeitenschneiderImage(seitenschneiderImage: UIImageView, position: CGFloat){
        self.view.addSubview(seitenschneiderImage)
        self.view.bringSubview(toFront: seitenschneiderImage)
        seitenschneiderImage.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.2).isActive = true
        seitenschneiderImage.heightAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.2).isActive = true
        seitenschneiderImage.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: position).isActive = true
        seitenschneiderImage.centerYAnchor.constraint(equalTo: self.view.topAnchor, constant: CGFloat(UIScreen.main.bounds.height*0.18)).isActive = true
    }
}
