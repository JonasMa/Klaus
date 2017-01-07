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
        
        
        UITabBar.appearance().tintColor = Style.accentColor;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
