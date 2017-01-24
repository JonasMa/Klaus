//
//  ResultViewController.swift
//  Klaus
//
//  Created by Oliver Pieper on 29.12.16.
//  Copyright © 2016 Nimm Swag. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {

    @IBOutlet weak var resultLabel: UILabel!
    var result: Double = 0.0
    
    @IBAction func backButton(_ sender: UIButton) {
        NSLog("BackButton gedrückt.")
    }
    
    init(result: Double){
        super.init(nibName: "ResultViewController", bundle: nil)
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.result = round(10000 * result) / 10000
        AppModel.sharedInstance.personalScore = result
        handleScore()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Simply displays result value as a type Double
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
