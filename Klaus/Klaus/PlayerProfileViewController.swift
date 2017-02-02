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
        super.viewWillAppear(animated);
        NotificationCenter.default.addObserver(forName: NotificationCenterKeys.updatePlayerScoreNotification, object: nil, queue: nil, using: updateScore)
        
        NotificationCenter.default.addObserver(forName: NotificationCenterKeys.updatePlayerLevelNotification, object: nil, queue: nil, using: updatePlayerLevel)
        
        profileNameLabel.text = profile!.name;
        profileNameLabel.textColor = Style.primaryTextColor
        let text = NSMutableAttributedString(string: "Level ", attributes: [NSFontAttributeName: Style.smallTextFont]);
        text.append(NSMutableAttributedString(string: String(profile!.profileLevel), attributes: [NSFontAttributeName: Style.bodyTextFont]));
        profileLevelLabel.attributedText = text
        
        profileImageView.image = UIImage(named: profile!.profileAvatar)?.withRenderingMode(.alwaysTemplate)
        profileImageView.tintColor = profile!.profileColor;
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated);
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if firstLaunch {
            let vc = TutorialPageViewController(nibName: "TutorialPageViewController", bundle: nil);
            vc.modalTransitionStyle = .partialCurl
            self.present(vc, animated: false, completion: nil);
            firstLaunch = false;
            BluetoothController.sharedInstance.stop()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(forName: NotificationCenterKeys.presentTutorialNotification, object: nil, queue: nil, using: presentTutorial);

        
        BluetoothController.sharedInstance.setPassive()
        
        profile = AppModel.sharedInstance.player;
        //ITEM COLLECTION
        itemCollectionViewController = PlayerItemCollectionViewController();
        itemCollectionViewController.items = profile.items;
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
        let text = NSMutableAttributedString(string: score!, attributes: [NSFontAttributeName: Style.bodyTextFont]);
        text.append(NSMutableAttributedString(string: " (\(scorePerSecond!)/min)", attributes: [NSFontAttributeName: Style.smallTextFont]));
        
        profileScoreLabel.attributedText = text;
            
    }
    
    func updatePlayerLevel(notification:Notification){
        let level = notification.userInfo?["level"] as? String;
        let text = NSMutableAttributedString(string: "Level ", attributes: [NSFontAttributeName: Style.smallTextFont]);
        text.append(NSMutableAttributedString(string: level!, attributes: [NSFontAttributeName: Style.bodyTextFont]));

        profileLevelLabel.attributedText = text;
        profile.profileLevel = Int(level!)
    }
    
    func presentTutorial(notification:Notification){
        firstLaunch = true;
    }

}
