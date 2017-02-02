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
        NotificationCenter.default.addObserver(forName: NotificationCenterKeys.updateEnemyLevelNotification, object: nil, queue: nil, using: updateScore)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated);
        NotificationCenter.default.removeObserver(self, name: NotificationCenterKeys.updateEnemyLevelNotification, object: nil);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //ITEM COLLECTION
        itemCollectionViewController = EnemyItemCollectionViewController();
        itemCollectionViewController.items = profile.items;
        itemCollectionViewController.enemyUuid = profile.uuid;
        self.addChildViewController(itemCollectionViewController);
        self.view.addSubview(itemCollectionViewController.view);
        
        self.title = profile.name;
        super.addConstraints();
        
        profileNameLabel.text = profile.name;
        profileScoreLabel.text = String(profile.score);
        profileImageView.image = UIImage(named: profile.profileAvatar)?.withRenderingMode(.alwaysTemplate);
        profileImageView.tintColor = profile.profileColor

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func updateScore(notification:Notification){
        let level = notification.userInfo?["level"] as? String;
        
        let text = NSMutableAttributedString(string: "Level ", attributes: [NSFontAttributeName: Style.smallTextFont]);
        text.append(NSMutableAttributedString(string: level!, attributes: [NSFontAttributeName: Style.bodyTextFont]));
        profileScoreLabel.attributedText = text;
    }


}
