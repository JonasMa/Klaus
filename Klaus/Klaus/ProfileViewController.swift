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
    var grad: CAGradientLayer!;
    
    var itemCollectionViewController: ItemCollectionViewController!;
    
    
    override func loadView() {
        self.view = ProfileView(frame: UIScreen.main.bounds);
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        //BACKGROUND
        grad = CAGradientLayer();
        grad.colors = [Style.bg.cgColor,Style.bgTransparent.cgColor];
        grad.startPoint = CGPoint(x: 0.5, y: 0.35)
        grad.endPoint = CGPoint(x: 0.5, y: 0.45)
        grad.frame = self.view.bounds;
        
        self.view.backgroundColor = Style.bg;
        //IMAGE
        profileImageView = UIImageView(frame: CGRect());
        profileImageView.translatesAutoresizingMaskIntoConstraints = false;
        self.view.addSubview(profileImageView);
        
        //STATS - name - score
        profileStatsView = UIView(frame: CGRect());
        profileStatsView.translatesAutoresizingMaskIntoConstraints = false;
        self.view.addSubview(profileStatsView);

        
        profileNameLabel = UILabel();
        profileNameLabel.translatesAutoresizingMaskIntoConstraints = false;
        profileNameLabel.font = UIFont.boldSystemFont(ofSize: 16);
        profileNameLabel.textColor = Style.primaryTextColor;
        profileStatsView.addSubview(profileNameLabel);
        
        profileScoreLabel = UILabel();
        profileScoreLabel.translatesAutoresizingMaskIntoConstraints = false;
        profileScoreLabel.font = UIFont.systemFont(ofSize: 11);
        profileScoreLabel.textColor = Style.primaryTextColor;
        profileStatsView.addSubview(profileScoreLabel);
    
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

        itemCollectionViewController.collectionView?.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor).isActive = true;
        itemCollectionViewController.collectionView?.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true;
        itemCollectionViewController.collectionView?.bottomAnchor.constraint(equalTo: self.bottomLayoutGuide.topAnchor).isActive = true;
        itemCollectionViewController.collectionView?.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true;

    }
    
}
