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
    var vc = GameViewController()
    var id: Int = 0
    
    //Calls appropriate GameController
    @IBAction func startButton(_ sender: UIButton) {
        navigationController?.pushViewController(vc, animated: true)
    }
    
    init(id: Int){
        super.init(nibName: "ExplanationViewController", bundle: nil)
        self.id = id
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegateGameController()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //TODO: attach appropriate GameControllers and Explanation Strings
    func delegateGameController() -> Void {
        switch id {
        case 1:
            vc = GameViewController(nibName: "GameViewController", bundle: nil)
            explanationLabel.text = Strings.axeGameExplanation
            break
        case 2:
            vc = GameViewController(nibName: "GameViewController", bundle: nil)
            explanationLabel.text = Strings.simonSaysExplanation
            break
        case 3:
            vc = GameViewController(nibName: "GameViewController", bundle: nil)
            explanationLabel.text = Strings.shelfGameExplanation
            break
        case 4:
            vc = GameViewController(nibName: "GameViewController", bundle: nil)
            explanationLabel.text = Strings.fourthGameExplanation
            break
        default:
            break
        }
    }

}
