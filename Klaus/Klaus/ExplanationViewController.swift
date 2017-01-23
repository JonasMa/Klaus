//
//  ExplanationViewController.swift
//  Klaus
//
//  Created by Oliver Pieper on 29.12.16.
//  Copyright © 2016 Nimm Swag. All rights reserved.
//
//  Overall ExplanationViewController which is used by every Minigame

import UIKit

class ExplanationViewController: UIViewController {

    @IBOutlet weak var explanationLabel: UILabel!
    var vc = UIViewController()
    var id: Int = 0
    var item: Item!;
    
    //Calls appropriate GameController
    @IBAction func startButton(_ sender: UIButton) {
        navigationController?.pushViewController(vc, animated: true)
    }
    
    init(item: Item){
        super.init(nibName: "ExplanationViewController", bundle: nil)
        self.item = item;
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: false)
        delegateGameController()
    }
    
    //TODO: attach appropriate GameControllers and Explanation Strings
    func delegateGameController() -> Void {
        explanationLabel.text = item.getGameExplanation();
        vc = item.getAssociatedGameViewController();
    }

}
