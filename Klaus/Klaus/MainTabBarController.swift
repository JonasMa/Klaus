//
//  MainTabBarController.swift
//  Klaus
//
//  Created by Alex Knittel on 26.12.16.
//  Copyright © 2016 Nimm Swag. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        UITabBar.appearance().tintColor = Style.vermillion;
        
//        blur tabbar
//        self.tabBar.backgroundImage = UIImage();
//        let blur = UIVisualEffectView(effect: UIBlurEffect(style: .light));
//        blur.frame = self.tabBar.bounds;
//        self.tabBar.insertSubview(blur, at: 0);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
