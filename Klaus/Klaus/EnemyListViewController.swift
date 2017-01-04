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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "EnemyListView";
        enemyTableViewController = EnemyTableViewController()
        self.addChildViewController(enemyTableViewController);
        self.view.addSubview(enemyTableViewController.view);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
