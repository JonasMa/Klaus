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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        //BACKGROUND
        let freshGradient = CAGradientLayer();
        freshGradient.colors = [Style.fresh2.cgColor,Style.fresh.cgColor];
        freshGradient.frame = self.view.bounds;
        freshGradient.startPoint = CGPoint(x: 0.0, y: 0.0);
        freshGradient.endPoint = CGPoint(x: 1.0, y: 1.0);
        self.view.layer.addSublayer(freshGradient);

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
        profileNameLabel.font = UIFont.boldSystemFont(ofSize: 30);
        profileNameLabel.textColor = Style.clean;
        profileNameLabel.shadowColor = Style.vermillion
        profileStatsView.addSubview(profileNameLabel);
        
        profileScoreLabel = UILabel();
        profileScoreLabel.translatesAutoresizingMaskIntoConstraints = false;
        profileScoreLabel.font = UIFont.systemFont(ofSize: 20);
        profileScoreLabel.textColor = Style.clean;
        profileScoreLabel.shadowColor = Style.vermillion;
        profileStatsView.addSubview(profileScoreLabel);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func addConstraints(){
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

        itemCollectionViewController.collectionView?.topAnchor.constraint(equalTo: profileImageView.bottomAnchor).isActive = true;
        itemCollectionViewController.collectionView?.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true;
        itemCollectionViewController.collectionView?.bottomAnchor.constraint(equalTo: self.bottomLayoutGuide.topAnchor).isActive = true;
        itemCollectionViewController.collectionView?.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true;
        
    }
    
}
