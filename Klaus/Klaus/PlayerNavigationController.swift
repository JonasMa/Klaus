//
//  ProfileNavigationController.swift
//  Klaus
//
//  Created by Alex Knittel on 24.12.16.
//  Copyright © 2016 Nimm Swag. All rights reserved.
//

import UIKit

class PlayerNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        let playerProfileViewController = PlayerProfileViewController();
        self.pushViewController(playerProfileViewController, animated: true)
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
