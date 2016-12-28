//
//  ProfileNavigationController.swift
//  Klaus
//
//  Created by Alex Knittel on 24.12.16.
//  Copyright © 2016 Nimm Swag. All rights reserved.
//

import UIKit

class ProfileNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        let playerProfileViewController = PlayerProfileViewController();
        self.pushViewController(playerProfileViewController, animated: true)
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
