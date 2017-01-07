//
//  EnemyNavigationController.swift
//  Klaus
//
//  Created by Alex Knittel on 28.12.16.
//  Copyright © 2016 Nimm Swag. All rights reserved.
//

import UIKit

class EnemyNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        let enemyListViewController = EnemyListViewController();
        self.pushViewController(enemyListViewController, animated: true);
        self.navigationBar.tintColor = Style.accentColor;
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
