//
//  AxeGameViewController.swift
//  Klaus
//
//  Created by Oliver Pieper on 29.12.16.
//  Copyright © 2016 Nimm Swag. All rights reserved.
//
//  Axe minigame controller

import UIKit

class AxeGameViewController: UIViewController {

    @IBOutlet weak var countdownValueLabel: UILabel!
    @IBOutlet weak var gametitleLabel: UILabel!
    
    let gameID = 0
    
    var accelerometerModel: AccelerometerModel!
    var countdown: CountdownModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gametitleLabel.font = Style.bodyTextFont
        countdownValueLabel.font = Style.bodyTextFont
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
        let vc = ResultViewController(result: accelerometerModel.endRecording(), gameID: gameID)
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

