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
        profileImageView  = UIImageView();
        profileImageView.image = UIImage(named: "axt")
        profileImageView.translatesAutoresizingMaskIntoConstraints = false;
        self.view.addSubview(profileImageView);
        
        //STATS - name - score - level
        profileStatsView = UIView(frame: CGRect());
        profileStatsView.translatesAutoresizingMaskIntoConstraints = false;
        self.view.addSubview(profileStatsView);

        profileNameLabel = UILabel();
        profileNameLabel.translatesAutoresizingMaskIntoConstraints = false;
        profileNameLabel.font = Style.bodyTextFont;
        profileNameLabel.textColor = Style.primaryTextColor;
        profileStatsView.addSubview(profileNameLabel);
        
        profileScoreLabel = UILabel();
        profileScoreLabel.translatesAutoresizingMaskIntoConstraints = false;
        profileScoreLabel.font = Style.smallTextFont;
        profileScoreLabel.textColor = Style.primaryTextColor;
        profileStatsView.addSubview(profileScoreLabel);
        
        profileLevelLabel = UILabel();
        profileLevelLabel.translatesAutoresizingMaskIntoConstraints = false;
        profileLevelLabel.font = Style.smallTextFont
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
        
        profileStatsView.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor).isActive = true;
        profileStatsView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true;
        profileStatsView.heightAnchor.constraint(equalTo: profileStatsView.widthAnchor).isActive = true;
        profileStatsView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.5).isActive = true;
        
        profileImageView.heightAnchor.constraint(equalTo: profileImageView.widthAnchor).isActive = true;
        
        profileImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: -(UIScreen.main.bounds.width * 0.25)).isActive = true;
        profileImageView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.3).isActive = true;
        profileImageView.centerYAnchor.constraint(equalTo: profileStatsView.centerYAnchor).isActive = true;
        
        
        profileNameLabel.bottomAnchor.constraint(equalTo: profileStatsView.centerYAnchor, constant: -20).isActive = true;
        profileNameLabel.centerXAnchor.constraint(equalTo: profileStatsView.centerXAnchor).isActive = true;
        
        profileScoreLabel.topAnchor.constraint(equalTo: profileLevelLabel.centerYAnchor, constant: 20).isActive = true;
        profileScoreLabel.centerXAnchor.constraint(equalTo: profileStatsView.centerXAnchor).isActive = true;
        
        profileLevelLabel.topAnchor.constraint(equalTo: profileNameLabel.centerYAnchor, constant: 20).isActive = true;
        profileLevelLabel.centerXAnchor.constraint(equalTo: profileStatsView.centerXAnchor).isActive = true;

        itemCollectionViewController.collectionView?.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor).isActive = true;
        itemCollectionViewController.collectionView?.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true;
        itemCollectionViewController.collectionView?.bottomAnchor.constraint(equalTo: self.bottomLayoutGuide.topAnchor).isActive = true;
        itemCollectionViewController.collectionView?.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true;
        
        

    }
}
