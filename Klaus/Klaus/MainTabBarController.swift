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
        self.tabBar.backgroundImage = UIImage();
        let blur = UIVisualEffectView(effect: UIBlurEffect(style: .light));
        blur.frame = self.tabBar.bounds;
        self.tabBar.insertSubview(blur, at: 0);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//        
//        
//    }
    

}
