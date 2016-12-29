//
//  GameViewController.swift
//  Klaus
//
//  Created by Oliver Pieper on 29.12.16.
//  Copyright © 2016 Nimm Swag. All rights reserved.
//
//  Axe minigame controller

import UIKit

class GameViewController: UIViewController {

    @IBOutlet weak var countdownValueLabel: UILabel!
    @IBOutlet weak var gametitleLabel: UILabel!
    
    var gameTimer: Timer!
    var accelerometerModel: AccelerometerModel!
    
    var count = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        accelerometerModel = AccelerometerModel()
        gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(update), userInfo: nil, repeats: true)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    func update() {
        if(count > 0) {
            count -= 1
            countdownValueLabel.text = String(count)
        }else if (count == 0) {
            gameTimer.invalidate()
            let vc = ResultViewController(nibName: "ResultViewController", bundle: nil)
            vc.result = accelerometerModel.endRecording() //sends result value to resultViewController
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

