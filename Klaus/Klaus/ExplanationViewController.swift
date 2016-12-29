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
    
    //Calls appropriate GameController
    @IBAction func startButton(_ sender: UIButton) {
        let vc = GameViewController(nibName: "GameViewController", bundle: nil)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //TODO: Display appropriate explanation text and receive appropriate minigame data
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
