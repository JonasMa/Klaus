//
//  PlayerProfileViewController.swift
//  Klaus
//
//  Created by Alex Knittel on 28.12.16.
//  Copyright © 2016 Nimm Swag. All rights reserved.
//

import UIKit

class PlayerProfileViewController: ProfileViewController {

    dynamic var test: NSArray!;
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //ITEM COLLECTION
        itemCollectionViewController = PlayerItemCollectionViewController();
        self.addChildViewController(itemCollectionViewController);
        self.view.addSubview(itemCollectionViewController.view);
        self.title = "PlayerProfileView";
        super.addConstraints();
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
