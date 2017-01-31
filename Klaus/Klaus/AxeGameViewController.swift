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
    
    let gameID = 0
    
    var accelerometerModel: AccelerometerModel!
    var countdown: CountdownModel!
    var axe: AxeModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        countdownValueLabel.font = Style.titleTextFontBold
        self.navigationItem.setHidesBackButton(true, animated: false)
        accelerometerModel = AccelerometerModel()
        countdown = CountdownModel(vc: self)
        axe = AxeModel()
        self.view.addSubview(axe)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    func updateLabel(countr: Int) -> Void {
        countdownValueLabel.text = "Du hast noch " + String(countr) + " Sekunden"
    }
    
    func startResultViewController() -> Void {
        let vc = ResultViewController(result: accelerometerModel.endRecording(), gameID: gameID)
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

