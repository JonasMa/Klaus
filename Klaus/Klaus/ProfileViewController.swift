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
        
        self.view.backgroundColor = UIColor.white;
        self.navigationController?.navigationBar.isHidden = true;
        
        playerItemCollectionViewController = PlayerItemCollectionViewController();
        self.addChildViewController(playerItemCollectionViewController);
        self.view.addSubview(playerItemCollectionViewController.view);
        
        profileImageView = UIImageView(frame: CGRect());
        profileImageView.translatesAutoresizingMaskIntoConstraints = false;
        profileImageView.backgroundColor = UIColor.gray;
        profileImageView.layer.borderColor = UIColor.white.cgColor
        profileImageView.layer.borderWidth = 3.0
        profileImageView.layer.cornerRadius = 15.0
        self.view.addSubview(profileImageView);
        
        profileStatsView = UIView(frame: CGRect());
        profileStatsView.translatesAutoresizingMaskIntoConstraints = false;
        profileStatsView.backgroundColor = UIColor.gray;
        profileStatsView.layer.borderColor = UIColor.white.cgColor
        profileStatsView.layer.borderWidth = 3.0
        profileStatsView.layer.cornerRadius = 15.0
        self.view.addSubview(profileStatsView);
        
        let imageTopConstraint = NSLayoutConstraint(item: profileImageView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 20);
        let imageHeightConstraint = NSLayoutConstraint(item: profileImageView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: profileImageView, attribute: NSLayoutAttribute.width, multiplier: 1, constant: 0);
        let imageLeftConstraint = NSLayoutConstraint(item: profileImageView, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.left, multiplier: 1, constant: 0);
        let imageWidthConstraint = NSLayoutConstraint(item: profileImageView, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.width, multiplier: 0.5, constant: 0);
        
            NSLayoutConstraint.activate([imageTopConstraint,imageHeightConstraint,imageLeftConstraint,imageWidthConstraint]);
        
        let statsTopConstraint = NSLayoutConstraint(item: profileStatsView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: profileImageView, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0);
        let statsBottomConstraint = NSLayoutConstraint(item: profileStatsView, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: profileImageView, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0);
        let statsLeftConstraint = NSLayoutConstraint(item: profileStatsView, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: profileImageView, attribute: NSLayoutAttribute.right, multiplier: 1, constant: 0);
        let statsRightConstraint = NSLayoutConstraint(item: profileStatsView, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.right, multiplier: 1, constant: 0);
        
        NSLayoutConstraint.activate([statsTopConstraint,statsBottomConstraint,statsLeftConstraint,statsRightConstraint]);
        
        let collectionTopConstraint = NSLayoutConstraint(item: playerItemCollectionViewController.collectionView!, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: profileImageView, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0);
        let collectionBottomConstraint = NSLayoutConstraint(item: playerItemCollectionViewController.collectionView!, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0);
        let collectionLeftConstraint = NSLayoutConstraint(item: playerItemCollectionViewController.collectionView!, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.left, multiplier: 1, constant: 0);
        let collectionRightConstraint = NSLayoutConstraint(item: playerItemCollectionViewController.collectionView!, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.right, multiplier: 1, constant: 0);
        
        NSLayoutConstraint.activate([collectionTopConstraint,collectionBottomConstraint,collectionLeftConstraint,collectionRightConstraint]);
        
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
