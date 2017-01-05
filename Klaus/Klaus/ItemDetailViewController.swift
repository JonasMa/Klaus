//
//  ItemDetailViewController.swift
//  Klaus
//
//  Created by Alex Knittel on 26.12.16.
//  Copyright © 2016 Nimm Swag. All rights reserved.
//

import UIKit

class ItemDetailViewController: UIViewController {
    
    var item:Item!;
    
    var itemImageContainer: UIView!;
    var itemImageView: UIImageView!;
    var itemNameLabel: UILabel!;
    var itemLevelLabel: UILabel!;
    var itemPointsLabel: UILabel!;
    
    override func loadView() {
        self.view = ItemDetailView(frame: UIScreen.main.bounds);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //BACKGROUND
        let freshGradient = CAGradientLayer();
        freshGradient.colors = [Style.fresh2.cgColor,Style.fresh.cgColor];
        freshGradient.frame = self.view.bounds;
        freshGradient.startPoint = CGPoint(x: 0.0, y: 0.0);
        freshGradient.endPoint = CGPoint(x: 1.0, y: 1.0);
        self.view.layer.addSublayer(freshGradient);
        
        //IMAGE - container for margins
        self.itemImageContainer = UIView();
        self.view.addSubview(itemImageContainer);
        self.itemImageContainer.translatesAutoresizingMaskIntoConstraints = false;
        
        self.itemImageView = UIImageView()
        self.itemImageView.image = UIImage(named: item.name.lowercased())?.withRenderingMode(.alwaysTemplate);
        self.itemImageView.tintColor = Style.clean;
        self.itemImageView.contentMode = UIViewContentMode.scaleAspectFit;
        self.itemImageView.translatesAutoresizingMaskIntoConstraints = false;
        self.itemImageView.layer.shadowColor = Style.vermillion.cgColor;
        self.itemImageView.layer.shadowOpacity = 0.9;
        self.itemImageView.layer.shadowRadius = 2;
        self.itemImageContainer.addSubview(itemImageView);
        
        //ITEMLEVEL
        self.itemLevelLabel = UILabel();
        self.itemLevelLabel.text = String(item.itemLevel);
        self.itemLevelLabel.font = UIFont.boldSystemFont(ofSize: 90);
        self.itemLevelLabel.textAlignment = .center;
        self.itemLevelLabel.translatesAutoresizingMaskIntoConstraints = false;
        self.itemLevelLabel.textColor = Style.clean;
        self.itemLevelLabel.layer.shadowColor = Style.vermillion.cgColor;
        self.itemLevelLabel.layer.shadowOpacity = 0.9;
        self.itemLevelLabel.layer.shadowRadius = 2;
        self.view.addSubview(itemLevelLabel);
        
        //POINTS PER SECOND
//        self.itemPointsLabel = UILabel();
//        self.itemPointsLabel.text = String(item.pointsPerSecond);
//        self.itemPointsLabel.font = UIFont.systemFont(ofSize: 20);
//        self.itemPointsLabel.translatesAutoresizingMaskIntoConstraints = false;
//        self.view.addSubview(itemPointsLabel);
        
        //ITEMNAME
        self.itemNameLabel = UILabel();
        self.itemNameLabel.text = item.name.uppercased();
        self.itemNameLabel.translatesAutoresizingMaskIntoConstraints = false;
        self.itemNameLabel.textAlignment = .center;
        self.itemNameLabel.font = UIFont.boldSystemFont(ofSize: 40.0);
        self.itemNameLabel.textColor = Style.clean;
        self.itemNameLabel.layer.shadowColor = Style.vermillion.cgColor;
        self.itemNameLabel.layer.shadowOpacity = 1;
        self.itemNameLabel.layer.shadowRadius = 1;
        self.itemNameLabel.layer.shadowOffset = CGSize(width: 0, height: 0);
        self.view.addSubview(itemNameLabel);
        
        //CONSTRAINTS
        itemImageView.topAnchor.constraint(equalTo: itemImageContainer.topAnchor, constant: 30).isActive = true;
        itemImageView.leftAnchor.constraint(equalTo: itemImageContainer.leftAnchor, constant: 30).isActive = true;
        itemImageView.bottomAnchor.constraint(equalTo: itemImageContainer.bottomAnchor, constant: -30).isActive = true;
        itemImageView.rightAnchor.constraint(equalTo: itemImageContainer.rightAnchor, constant: -30).isActive = true;
        
        itemImageContainer.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor).isActive = true;
        itemImageContainer.heightAnchor.constraint(equalTo: itemImageContainer.widthAnchor).isActive = true;
        itemImageContainer.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true;
        itemImageContainer.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.5).isActive = true;
        
        itemLevelLabel.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor).isActive = true;
        itemLevelLabel.leftAnchor.constraint(equalTo: itemImageContainer.rightAnchor).isActive = true;
        itemLevelLabel.bottomAnchor.constraint(equalTo: itemImageContainer.bottomAnchor).isActive = true;
        itemLevelLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true;
        
        itemNameLabel.centerYAnchor.constraint(equalTo: itemImageContainer.bottomAnchor).isActive = true;
        itemNameLabel.leftAnchor.constraint(equalTo: itemImageContainer.centerXAnchor).isActive = true;
        itemNameLabel.rightAnchor.constraint(equalTo: itemLevelLabel.centerXAnchor).isActive = true;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
