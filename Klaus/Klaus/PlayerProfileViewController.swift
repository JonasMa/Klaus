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
    var clearPlayerDataButton: UIButton!;
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        NotificationCenter.default.addObserver(forName: NotificationCenterKeys.updatePlayerScoreNotification, object: nil, queue: nil, using: updateScore)
        
        // Muss noch geändert werden
        NotificationCenter.default.addObserver(forName: NotificationCenterKeys.updatePlayerLevelNotification, object: nil, queue: nil, using: updatePlayerLevel)
        
        profileNameLabel.text = profile!.name;
        profileNameLabel.textColor = profile!.profileColor
        profileLevelLabel.text = String(profile!.profileLevel)
        profileImageView.image = UIImage(named: profile!.profileAvatar)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated);
        NotificationCenter.default.removeObserver(self, name: NotificationCenterKeys.updatePlayerScoreNotification, object: nil);
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if firstLaunch {
            let vc = TutorialPageViewController(nibName: "TutorialPageViewController", bundle: nil);
            vc.modalTransitionStyle = .partialCurl
            self.present(vc, animated: false, completion: nil);
            firstLaunch = false;
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
        
        self.clearPlayerDataButton = UIButton(type: .roundedRect);
        self.clearPlayerDataButton.setTitle("Profil zurücksetzen", for: .normal);
        self.clearPlayerDataButton.addTarget(self, action: #selector(resetProfile), for: .touchDown);
        self.clearPlayerDataButton.translatesAutoresizingMaskIntoConstraints = false;
        
        super.addConstraints();
        
        self.view.addSubview(clearPlayerDataButton);

        
        clearPlayerDataButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true;
        clearPlayerDataButton.bottomAnchor.constraint(equalTo: self.bottomLayoutGuide.topAnchor).isActive = true;
        
        profileScoreLabel.text = String(profile!.score);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func updateScore(notification:Notification){
        let score = notification.userInfo?["score"] as? String;
        let scorePerSecond = notification.userInfo?["scorePerSecond"] as? String;
        profileScoreLabel.text = score! + " (" +  scorePerSecond! + "/min)";
    }
    
    func updatePlayerLevel(notification:Notification){
        let level = notification.userInfo?["level"] as? String;
        profileLevelLabel.text = level!
        profile.profileLevel = Int(level!)
    }
    
    func presentTutorial(notification:Notification){
        firstLaunch = true;
    }
    
    func resetProfile(){
        Config.clearPlayerDataOnNextLaunch = true;
        
        let alert = UIAlertController(title: "Profildaten gelöscht!", message: "Bitte starte die App neu, um dein neues Profil anzulegen.", preferredStyle: .alert);
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil));
        self.present(alert, animated: true, completion: nil);
        
    }
    


}
