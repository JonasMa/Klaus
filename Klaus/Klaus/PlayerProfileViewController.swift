//
//  PlayerProfileViewController.swift
//  Klaus
//
//  Created by Alex Knittel on 28.12.16.
//  Copyright © 2016 Nimm Swag. All rights reserved.
//

import UIKit

class PlayerProfileViewController: ProfileViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //ITEM COLLECTION
        itemCollectionViewController = PlayerItemCollectionViewController();
        self.addChildViewController(itemCollectionViewController);
        self.view.addSubview(itemCollectionViewController.view);
        
        self.title = "My Profile";
        super.addConstraints();
        
        profileNameLabel.text = AppModel.sharedInstance.player.name;
        profileScoreLabel.text = String(AppModel.sharedInstance.player.score);

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
