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
    
    var accelerometerModel: AccelerometerModel!
    var countdown: CountdownModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: false)
        accelerometerModel = AccelerometerModel()
        countdown = CountdownModel(vc: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    func updateLabel(countr: Int) -> Void {
        countdownValueLabel.text = String(countr)
    }
    
    func startResultViewController() -> Void {
        let vc = ResultViewController(result: accelerometerModel.endRecording())
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

