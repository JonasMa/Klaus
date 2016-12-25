//
//  ProfileViewController.swift
//  Klaus
//
//  Created by Alex Knittel on 25.12.16.
//  Copyright © 2016 Nimm Swag. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    var profileImageView: UIImageView!;
    var profileStatsView: UIView!;
    
    var playerItemCollectionViewController: PlayerItemCollectionViewController!;
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: Bundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    convenience init() {
        self.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        self.view = ProfileView(frame: UIScreen.main.bounds);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        self.view.backgroundColor = UIColor.red;
        
        playerItemCollectionViewController = PlayerItemCollectionViewController();
        self.addChildViewController(playerItemCollectionViewController);
        self.view.addSubview(playerItemCollectionViewController.view);
        
        profileImageView = UIImageView(frame: CGRect(x:0,y:0, width: 200,height:200));
        profileImageView.backgroundColor = UIColor.gray;
        profileImageView.layer.borderColor = UIColor.white.cgColor
        profileImageView.layer.borderWidth = 1.0
        profileImageView.layer.cornerRadius = 5.0
        self.view.addSubview(profileImageView);
        
        profileStatsView = UIView(frame: CGRect(x:20,y:100, width: 200,height:200))
        profileStatsView.backgroundColor = UIColor.blue;
        self.view.addSubview(profileStatsView);
        
        //self.view.addConstraint(NSLayoutConstraint(item: playerItemCollectionViewController.collectionView!, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.height, multiplier: 1, constant: -100));
        
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
