//
//  PlayerProfileViewController.swift
//  Klaus
//
//  Created by Alex Knittel on 28.12.16.
//  Copyright © 2016 Nimm Swag. All rights reserved.
//

import UIKit

class PlayerProfileViewController: ProfileViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(forName: NotificationCenterKeys.updatePlayerScoreNotification, object: nil, queue: nil, using: updateScore)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NotificationCenterKeys.updatePlayerScoreNotification, object: nil);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CentralPeripheralController.sharedInstance.setPassive()
        
        let profile = AppModel.sharedInstance.player;
        //ITEM COLLECTION
        itemCollectionViewController = PlayerItemCollectionViewController();
        itemCollectionViewController.profile = profile;
        self.addChildViewController(itemCollectionViewController);
        self.view.addSubview(itemCollectionViewController.view);
        
        self.title = "Profil";
        super.addConstraints();
        
        profileNameLabel.text = profile!.name;
        profileScoreLabel.text = String(profile!.score);
        
        //AppModel.sharedInstance.saveData();
                

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func updateScore(notification:Notification){
        let score = notification.userInfo?["score"] as? String;
        let scorePerSecond = notification.userInfo?["scorePerSecond"] as? String;
        profileScoreLabel.text = score! + " (" +  scorePerSecond! + "/s)";
    }

}
