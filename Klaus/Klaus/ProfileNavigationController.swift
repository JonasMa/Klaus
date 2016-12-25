//
//  ProfileNavigationController.swift
//  Klaus
//
//  Created by Alex Knittel on 24.12.16.
//  Copyright © 2016 Nimm Swag. All rights reserved.
//

import UIKit

class ProfileNavigationController: UINavigationController {
    
//    override init(rootViewController: UIViewController){
//        let profileViewController = ProfileViewController();
//        super.init(rootViewController: profileViewController);
//        
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
//        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
//    }
    
    
    override func viewDidLoad() {
        let profileViewController = ProfileViewController();
        self.pushViewController(profileViewController, animated: true)
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
