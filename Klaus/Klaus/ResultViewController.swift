//
//  ResultViewController.swift
//  Klaus
//
//  Created by Oliver Pieper on 29.12.16.
//  Copyright © 2016 Nimm Swag. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    let axe = 0
    let simon = 1
    let shelf = 2
    let seitenschneider = 3
    
    var result: Double = 0.0
    var resultAsString = " "
    var gameID: Int!
    
    @IBAction func backButton(_ sender: UIButton) {
        _ = navigationController?.popToRootViewController(animated: true)
    }
    
    init(result: Double, gameID: Int){
        super.init(nibName: "ResultViewController", bundle: nil)
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.result = round(10000 * result) / 10000
        AppModel.sharedInstance.personalScore = self.result
        //self.resultAsString = String(format: "%g", self.result)
        self.gameID = gameID
        handleScore()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLabels()
    }
    
    func handleScore() {
        NSLog("Score ResultView: \(result))")
        AppModel.sharedInstance.sendOwnScoreToEnemy(score: result)
        AppModel.sharedInstance.pushScore(score: result)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    func setLabels() {
        switch gameID {
        case axe:
            titleLabel.text = Strings.axeGameTitle
            descriptionLabel.text = Strings.axeGameResult + resultAsString
            break
        case simon:
            titleLabel.text = Strings.simonSaysTitle
            descriptionLabel.text = Strings.simonSaysResultPt1 + resultAsString + Strings.simonSaysResultPt2
            break
        case shelf:
            titleLabel.text = Strings.shelfGameTitle
            descriptionLabel.text = Strings.shelfGameResultPt1 + resultAsString + Strings.shelfGameResultPt2
            break
        case seitenschneider:
            titleLabel.text = Strings.seitenschneiderTitle
            descriptionLabel.text = Strings.seitenschneiderResultPt1 + resultAsString + Strings.seitenschneiderResultPt2
            break
        default:
            break
        }
    }
}
