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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        NotificationCenter.default.addObserver(forName: NotificationCenterKeys.updateEnemyScoreNotification, object: nil, queue: nil, using: updateScore)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated);
        NotificationCenter.default.removeObserver(self, name: NotificationCenterKeys.updateEnemyScoreNotification, object: nil);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //ITEM COLLECTION
        itemCollectionViewController = EnemyItemCollectionViewController();
        itemCollectionViewController.items = profile.items;
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
    
    func updateScore(notification:Notification){
        let score = notification.userInfo?["score"] as? String;
        profileScoreLabel.text = score!;
    }


}
