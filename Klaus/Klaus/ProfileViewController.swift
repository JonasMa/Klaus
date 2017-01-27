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
    var profileLevelLabel: UILabel!;
    var profileScoreLabel: UILabel!;
    
   // var avatarPath: String!;
    var grad: CAGradientLayer!;
    
    var itemCollectionViewController: ItemCollectionViewController!;
    
    override func loadView() {
        self.view = ProfileView(frame: UIScreen.main.bounds);
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        //BACKGROUND
        grad = CAGradientLayer();
        grad.colors = Style.gradientColors
        grad.locations = Style.gradientLocations();
        grad.frame = self.view.bounds;
        self.view.backgroundColor = Style.bg;
        
        //IMAGE
        print("second")
        profileImageView  = UIImageView(frame: CGRect(x:0, y:0, width:80, height:80));
        profileImageView.image = UIImage(named: "axt")
        profileImageView.translatesAutoresizingMaskIntoConstraints = false;
        self.view.addSubview(profileImageView);
        
        //STATS - name - score - level
        profileStatsView = UIView(frame: CGRect());
        profileStatsView.translatesAutoresizingMaskIntoConstraints = false;
        self.view.addSubview(profileStatsView);

        
        profileNameLabel = UILabel();
        profileNameLabel.translatesAutoresizingMaskIntoConstraints = false;
        profileNameLabel.font = UIFont.boldSystemFont(ofSize: 17);
        profileNameLabel.textColor = Style.primaryTextColor;
//        self.itemImageView.layer.shadowColor = item.itemColor.cgColor;
//        self.itemImageView.layer.shadowRadius = 5;
//        self.itemImageView.layer.shadowOpacity = 1;
//        self.itemImageView.layer.shadowOffset = CGSize(width: 0, height: 0);
        profileStatsView.addSubview(profileNameLabel);
        
        profileScoreLabel = UILabel();
        profileScoreLabel.translatesAutoresizingMaskIntoConstraints = false;
        profileScoreLabel.font = UIFont.systemFont(ofSize: 12);
        profileScoreLabel.textColor = Style.primaryTextColor;
        profileStatsView.addSubview(profileScoreLabel);
        
        profileLevelLabel = UILabel();
        profileLevelLabel.translatesAutoresizingMaskIntoConstraints = false;
        profileLevelLabel.font = UIFont.systemFont(ofSize: 12);
        profileLevelLabel.textColor = Style.primaryTextColor;
        profileStatsView.addSubview(profileLevelLabel);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func addConstraints(){
        
        self.view.layer.addSublayer(grad);

        self.view.bringSubview(toFront: profileStatsView);
        self.view.bringSubview(toFront: profileImageView);
        
        profileImageView.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor).isActive = true;
        profileImageView.heightAnchor.constraint(equalTo: profileImageView.widthAnchor).isActive = true;
        profileImageView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true;
        profileImageView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.5).isActive = true;
        
        profileStatsView.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor).isActive = true;
        profileStatsView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true;
        profileStatsView.bottomAnchor.constraint(equalTo: profileImageView.bottomAnchor).isActive = true;
        profileStatsView.leftAnchor.constraint(equalTo: profileImageView.rightAnchor).isActive = true;
        
        profileNameLabel.bottomAnchor.constraint(equalTo: profileStatsView.centerYAnchor).isActive = true;
        profileNameLabel.centerXAnchor.constraint(equalTo: profileStatsView.centerXAnchor).isActive = true;
        
        profileScoreLabel.topAnchor.constraint(equalTo: profileStatsView.centerYAnchor).isActive = true;
        profileScoreLabel.centerXAnchor.constraint(equalTo: profileStatsView.centerXAnchor).isActive = true;
        
        profileLevelLabel.topAnchor.constraint(equalTo: profileStatsView.centerYAnchor).isActive = true;
        profileLevelLabel.centerXAnchor.constraint(equalTo: profileStatsView.centerXAnchor).isActive = true;

        itemCollectionViewController.collectionView?.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor).isActive = true;
        itemCollectionViewController.collectionView?.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true;
        itemCollectionViewController.collectionView?.bottomAnchor.constraint(equalTo: self.bottomLayoutGuide.topAnchor).isActive = true;
        itemCollectionViewController.collectionView?.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true;
        
        

    }
}
