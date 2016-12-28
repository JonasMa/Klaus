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
    var profileNameLabel: UILabel!;
    var profileScoreLabel: UILabel!;
    
    var itemCollectionViewController: ItemCollectionViewController!;
    
    
    override func loadView() {
        self.view = ProfileView(frame: UIScreen.main.bounds);
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        let freshGradient = CAGradientLayer();
        freshGradient.colors = [Style.fresh2.cgColor,Style.fresh.cgColor];
        freshGradient.frame = self.view.bounds;
        freshGradient.startPoint = CGPoint(x: 0.0, y: 0.0);
        freshGradient.endPoint = CGPoint(x: 1.0, y: 1.0);
        self.view.layer.addSublayer(freshGradient);

        //ITEM COLLECTION
        itemCollectionViewController = ItemCollectionViewController();
        self.addChildViewController(itemCollectionViewController);
        self.view.addSubview(itemCollectionViewController.view);
        
        //IMAGE
        profileImageView = UIImageView(frame: CGRect());
        profileImageView.translatesAutoresizingMaskIntoConstraints = false;
        self.view.addSubview(profileImageView);
        
        //STATS
        profileStatsView = UIView(frame: CGRect());
        profileStatsView.translatesAutoresizingMaskIntoConstraints = false;
        self.view.addSubview(profileStatsView);
        
        profileNameLabel = UILabel();
        profileNameLabel.translatesAutoresizingMaskIntoConstraints = false;
        profileNameLabel.text = "name";//for testing
        profileNameLabel.font = UIFont.boldSystemFont(ofSize: 30);
        profileNameLabel.textColor = Style.clean;
        profileNameLabel.shadowColor = Style.vermillion
        profileStatsView.addSubview(profileNameLabel);
        
        profileScoreLabel = UILabel();
        profileScoreLabel.translatesAutoresizingMaskIntoConstraints = false;
        profileScoreLabel.text = "1337";//for testing
        profileScoreLabel.font = UIFont.systemFont(ofSize: 20);
        profileScoreLabel.textColor = Style.clean;
        profileScoreLabel.shadowColor = Style.vermillion;
        profileStatsView.addSubview(profileScoreLabel);
        
        
        
        //CONSTRAINTS
        profileNameLabel.bottomAnchor.constraint(equalTo: profileStatsView.centerYAnchor).isActive = true;
        profileNameLabel.centerXAnchor.constraint(equalTo: profileStatsView.centerXAnchor).isActive = true;
        
        profileScoreLabel.topAnchor.constraint(equalTo: profileStatsView.centerYAnchor).isActive = true;
        profileScoreLabel.centerXAnchor.constraint(equalTo: profileStatsView.centerXAnchor).isActive = true;
        
        
        //TODO: simplify
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
        
        let collectionTopConstraint = NSLayoutConstraint(item: itemCollectionViewController.collectionView!, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: profileImageView, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0);
        let collectionBottomConstraint = NSLayoutConstraint(item: itemCollectionViewController.collectionView!, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0);
        let collectionLeftConstraint = NSLayoutConstraint(item: itemCollectionViewController.collectionView!, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.left, multiplier: 1, constant: 0);
        let collectionRightConstraint = NSLayoutConstraint(item: itemCollectionViewController.collectionView!, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.right, multiplier: 1, constant: 0);
        
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
