//
//  EnemyListViewController.swift
//  Klaus
//
//  Created by Alex Knittel on 28.12.16.
//  Copyright © 2016 Nimm Swag. All rights reserved.
//

import UIKit

class EnemyListViewController: UIViewController {

    var enemyTableViewController: EnemyTableViewController!;
    
    override func loadView() {
        self.view = EnemyListView(frame: UIScreen.main.bounds);
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        CentralPeripheralController.sharedInstance.setPassive()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        CentralPeripheralController.sharedInstance.discoverEnemies()
        
        //for testing
        AppModel.sharedInstance.addEnemyToList(enemy: EnemyProfile(name: "Gerlinde"));
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Gegner in der Nähe";
        enemyTableViewController = EnemyTableViewController()
        self.addChildViewController(enemyTableViewController);
        self.view.addSubview(enemyTableViewController.view);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
