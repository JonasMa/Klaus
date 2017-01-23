//
//  MainTabBarController.swift
//  Klaus
//
//  Created by Alex Knittel on 26.12.16.
//  Copyright © 2016 Nimm Swag. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    let tabOne = UINavigationController()
    let tabTwo = UINavigationController();
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        
            }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(forName: NotificationCenterKeys.startGameFromEnemyTrigger, object: nil, queue: nil, using: triggerExplanationView)
        
        let tabOneBarItem = UITabBarItem(title: "Profil", image: UIImage(named: "profileTab"), tag: 0);
        let tabTwoBarItem = UITabBarItem(title: "Gegner", image: UIImage(named: "enemyTab"), tag: 1);
        
        tabOne.tabBarItem = tabOneBarItem;
        tabTwo.tabBarItem = tabTwoBarItem;
        
        self.viewControllers = [tabOne,tabTwo];
        let playerProfileViewController = PlayerProfileViewController();
        tabOne.pushViewController(playerProfileViewController, animated: true)
        
        let enemyListViewController = EnemyListViewController();
        tabTwo.pushViewController(enemyListViewController, animated: true);
        

        UITabBar.appearance().tintColor = Style.accentColor;
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func triggerExplanationView(notification:Notification) {
        let vc = ExplanationViewController(item: notification.userInfo?["item"] as! Item)
        tabTwo.pushViewController(vc, animated: true)
    }

}
