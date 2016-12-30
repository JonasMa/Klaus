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
        accelerometerModel = AccelerometerModel()
        countdown = CountdownModel(vc: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    func updateLabel(countr: Int) -> Void {
        countdownValueLabel.text = String(countr)
    }
    
    func startResultView() -> Void {
        let vc = ResultViewController(nibName: "ResultViewController", bundle: nil)
        vc.result = accelerometerModel.endRecording() //sends result value to resultViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

