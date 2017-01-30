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
    var resultAsString: String!
    var gameID: Int!
    
    @IBAction func backButton(_ sender: UIButton) {
        _ = navigationController?.popToRootViewController(animated: true)
    }
    
    init(result: Double, gameID: Int){
        super.init(nibName: "ResultViewController", bundle: nil)
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.result = round(10000 * result) / 10000
        self.resultAsString = String(self.result)
        self.gameID = gameID
        AppModel.sharedInstance.personalScore = self.result
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
            descriptionLabel.text = Strings.simonSaysResult + resultAsString
            break
        case shelf:
            titleLabel.text = Strings.shelfGameTitle
            descriptionLabel.text = Strings.shelfGameResult + resultAsString
            break
        case seitenschneider:
            titleLabel.text = Strings.seitenschneiderTitle
            descriptionLabel.text = Strings.seitenschneiderResult + resultAsString
            break
        default:
            break
        }
    }
}
