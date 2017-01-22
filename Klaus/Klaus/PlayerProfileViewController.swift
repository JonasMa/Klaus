//
//  PlayerProfileViewController.swift
//  Klaus
//
//  Created by Alex Knittel on 28.12.16.
//  Copyright © 2016 Nimm Swag. All rights reserved.
//

import UIKit

class PlayerProfileViewController: ProfileViewController {
    
    var profile: PlayerProfile!;
    var firstLaunch = false;
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(forName: NotificationCenterKeys.updatePlayerScoreNotification, object: nil, queue: nil, using: updateScore)
        profileNameLabel.text = profile!.name;

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NotificationCenterKeys.updatePlayerScoreNotification, object: nil);
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if firstLaunch {
            let vc = TutorialPageViewController(nibName: "TutorialPageViewController", bundle: nil);
            vc.modalTransitionStyle = .flipHorizontal;
            self.present(vc, animated: true, completion: nil);
            firstLaunch = false;
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(forName: NotificationCenterKeys.presentTutorialNotification, object: nil, queue: nil, using: presentTutorial);

        
        CentralPeripheralController.sharedInstance.setPassive()
        
        profile = AppModel.sharedInstance.player;
        //ITEM COLLECTION
        itemCollectionViewController = PlayerItemCollectionViewController();
        itemCollectionViewController.profile = profile;
        self.addChildViewController(itemCollectionViewController);
        self.view.addSubview(itemCollectionViewController.view);
        
        self.title = "Profil";
        super.addConstraints();
        
        profileScoreLabel.text = String(profile!.score);
        
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func updateScore(notification:Notification){
        let score = notification.userInfo?["score"] as? String;
        let scorePerSecond = notification.userInfo?["scorePerSecond"] as? String;
        profileScoreLabel.text = score! + " (" +  scorePerSecond! + "/s)";
    }
    
    func presentTutorial(notification:Notification){
        firstLaunch = true;
    }
    


}
