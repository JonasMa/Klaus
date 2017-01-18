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
        
        CentralPeripheralController.sharedInstance.setPassive()
        
        let profile = AppModel.sharedInstance.player;
        //ITEM COLLECTION
        itemCollectionViewController = PlayerItemCollectionViewController();
        itemCollectionViewController.profile = profile;
        self.addChildViewController(itemCollectionViewController);
        self.view.addSubview(itemCollectionViewController.view);
        
        self.title = "My Profile";
        super.addConstraints();
        
        profileNameLabel.text = profile.name;
        profileScoreLabel.text = String(profile.score);

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
