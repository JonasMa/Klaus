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
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    var result: Double = 0.0
    
    @IBAction func backButton(_ sender: UIButton) {
        _ = navigationController?.popToRootViewController(animated: true)
    }
    
    init(result: Double){
        super.init(nibName: "ResultViewController", bundle: nil)
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.result = round(10000 * result) / 10000
        AppModel.sharedInstance.personalScore = self.result
        handleScore()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resultLabel.text = String(result)
    }
    
    func handleScore() {
        AppModel.sharedInstance.sendOwnScoreToEnemy(score: result)
        AppModel.sharedInstance.pushScore(score: result)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
}
