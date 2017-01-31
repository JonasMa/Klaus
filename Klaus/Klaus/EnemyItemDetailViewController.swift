//
//  EnemyItemDetailViewController.swift
//  Klaus
//
//  Created by Alex Knittel on 28.12.16.
//  Copyright © 2016 Nimm Swag. All rights reserved.
//

import UIKit

class EnemyItemDetailViewController: ItemDetailViewController {
    
    var stealButton: UIButton!;
    private var g: CAGradientLayer!;

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //STEAL BUTTON
        stealButton = UIButton(type: UIButtonType.roundedRect);
        stealButton.translatesAutoresizingMaskIntoConstraints = false;
        stealButton.setTitle(Strings.stealButtonText, for: .normal);
        stealButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        stealButton.titleLabel?.font = Style.titleTextFont
        stealButton.tintColor = Style.primaryButtonTextColor

        g = Style.primaryButtonBackgroundGradient();
        stealButton.layer.insertSublayer(g, at: 0);
        self.view.addSubview(stealButton);
    
        self.title = "Details";
        
        NotificationCenter.default.addObserver(forName: NotificationCenterKeys.startGame, object: nil, queue: nil, using: startExplanationView)
        
        //CONSTRAINTS
        stealButton.bottomAnchor.constraint(equalTo: self.bottomLayoutGuide.topAnchor,constant: -8).isActive = true;
        
        stealButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 8).isActive = true;
        stealButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -8).isActive = true;
    }

    override func viewDidLayoutSubviews() {
        g.frame = stealButton.bounds
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func buttonAction(sender: UIButton!) {
        AppModel.sharedInstance.triggerEnemyGameInstance(stolenItem: item)
    }
    
    func startExplanationView(notification: Notification) {
        AppModel.sharedInstance.attackedItem = item
        AppModel.sharedInstance.isAttacking = true
        let vc = ExplanationViewController(item: item);
        navigationController?.pushViewController(vc, animated: true)
    }
}
