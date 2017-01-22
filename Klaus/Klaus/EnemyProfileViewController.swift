//
//  EnemyProfileViewController.swift
//  Klaus
//
//  Created by Alex Knittel on 28.12.16.
//  Copyright © 2016 Nimm Swag. All rights reserved.
//

import UIKit

class EnemyProfileViewController: ProfileViewController {
    
    var profile: EnemyProfile!;

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //ITEM COLLECTION
        itemCollectionViewController = EnemyItemCollectionViewController();
        itemCollectionViewController.profile = profile;
        self.addChildViewController(itemCollectionViewController);
        self.view.addSubview(itemCollectionViewController.view);
        
        self.title = profile.name;
        super.addConstraints();
        
        profileNameLabel.text = profile.name;
        profileScoreLabel.text = String(profile.score);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
