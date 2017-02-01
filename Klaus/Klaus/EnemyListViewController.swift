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
    
    //test
    let gerlinde = true; // gerlinde causes EXC_BAD_ACCESS on iPhone 6S
    
    override func loadView() {
        self.view = EnemyListView(frame: UIScreen.main.bounds);
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        BluetoothController.sharedInstance.setPassive()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        BluetoothController.sharedInstance.discoverEnemies()
        
        //for testing
        if(gerlinde){
            let e = EnemyProfile(name: "Gerlinde")
            e.setColor(color: UIColor.red);
            e.setAvatar(avatar: "coffee");
            e.uuid = ""
            AppModel.sharedInstance.addEnemyToList(enemy: e);
//            gerlinde = false;
        }

        
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
