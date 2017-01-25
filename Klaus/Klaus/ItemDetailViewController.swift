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
    var itemNameContainer: UIView!;
    var itemPointsLabel: UILabel!;
    var itemPointsValue: UILabel!;
    
    var grad: CAGradientLayer!;
    
    override func loadView() {
        self.view = ItemDetailView(frame: UIScreen.main.bounds);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = Style.bg;
        
        //BACKGROUND
        grad = CAGradientLayer();
        grad.colors = Style.gradientColors;
        grad.locations = Style.gradientLocations();
        grad.frame = self.view.bounds;
        self.view.layer.addSublayer(grad);
 
        
        //IMAGE - container for padding
        self.itemImageContainer = UIView();
        self.view.addSubview(itemImageContainer);
        self.itemImageContainer.translatesAutoresizingMaskIntoConstraints = false;
        
        self.itemImageView = UIImageView()
        self.itemImageView.image = UIImage(named: item.displayName.lowercased())?.withRenderingMode(.alwaysTemplate);
        self.itemImageView.tintColor = Style.primaryTextColor;
        self.itemImageView.contentMode = UIViewContentMode.scaleAspectFit;
        self.itemImageView.translatesAutoresizingMaskIntoConstraints = false;
        self.itemImageContainer.addSubview(itemImageView);
        
        //ITEMNAME
        self.itemNameContainer = UIView();
        self.itemNameContainer.translatesAutoresizingMaskIntoConstraints = false;
        self.view.addSubview(itemNameContainer);
        
        self.itemLevelLabel = UILabel();
        self.itemLevelLabel.text = String(item.itemLevel);
        self.itemLevelLabel.font = UIFont.systemFont(ofSize: 16);
        self.itemLevelLabel.textAlignment = .center;
        self.itemLevelLabel.translatesAutoresizingMaskIntoConstraints = false;
        self.itemLevelLabel.textColor = Style.primaryTextColor;
        self.itemNameContainer.addSubview(itemLevelLabel);

        self.itemNameLabel = UILabel();
        self.itemNameLabel.text = item.displayName.uppercased();
        self.itemNameLabel.translatesAutoresizingMaskIntoConstraints = false;
        self.itemNameLabel.textAlignment = .center;
        self.itemNameLabel.font = UIFont.boldSystemFont(ofSize: 16);
        self.itemNameLabel.textColor = Style.primaryTextColor;
        self.itemNameContainer.addSubview(itemNameLabel);
        
        //POINTS PER SECOND
        self.itemPointsLabel = UILabel();
        self.itemPointsLabel.text = String("Punkte/s");
        self.itemPointsLabel.font = UIFont.boldSystemFont(ofSize: 16);
        self.itemPointsLabel.translatesAutoresizingMaskIntoConstraints = false;
        self.itemPointsLabel.textAlignment = .left;
        self.view.addSubview(itemPointsLabel);
        
        self.itemPointsValue = UILabel();
        self.itemPointsValue.text = String(item.pointsPerSecond);
        self.itemPointsValue.font = UIFont.boldSystemFont(ofSize: 16);
        self.itemPointsValue.translatesAutoresizingMaskIntoConstraints = false;
        self.itemPointsValue.textAlignment = .right;
        self.view.addSubview(itemPointsValue);
        
        
        
        //CONSTRAINTS
        itemImageView.topAnchor.constraint(equalTo: itemImageContainer.topAnchor, constant: 50).isActive = true;
        itemImageView.leftAnchor.constraint(equalTo: itemImageContainer.leftAnchor, constant: 50).isActive = true;
        itemImageView.bottomAnchor.constraint(equalTo: itemImageContainer.bottomAnchor, constant: -50).isActive = true;
        itemImageView.rightAnchor.constraint(equalTo: itemImageContainer.rightAnchor, constant: -50).isActive = true;
        
        itemImageContainer.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor).isActive = true;
        itemImageContainer.heightAnchor.constraint(equalTo: itemImageContainer.widthAnchor).isActive = true;
        itemImageContainer.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true;
        itemImageContainer.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.5).isActive = true;
        
        itemNameContainer.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor).isActive = true;
        itemNameContainer.leftAnchor.constraint(equalTo: itemImageContainer.rightAnchor).isActive = true;
        itemNameContainer.bottomAnchor.constraint(equalTo: itemImageContainer.bottomAnchor).isActive = true;
        itemNameContainer.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true;
        
        itemNameLabel.bottomAnchor.constraint(equalTo: itemNameContainer.centerYAnchor).isActive = true;
        itemNameLabel.centerXAnchor.constraint(equalTo: itemNameContainer.centerXAnchor).isActive = true;
        
        itemLevelLabel.topAnchor.constraint(equalTo: itemNameContainer.centerYAnchor).isActive = true;
        itemLevelLabel.centerXAnchor.constraint(equalTo: itemNameContainer.centerXAnchor).isActive = true;
        
        itemPointsLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 5).isActive = true;
        itemPointsLabel.rightAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true;
        itemPointsLabel.topAnchor.constraint(equalTo: itemImageContainer.bottomAnchor,constant: 10).isActive = true;
        
        itemPointsValue.leftAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true;
        itemPointsValue.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -5).isActive = true;
        itemPointsValue.topAnchor.constraint(equalTo: itemImageContainer.bottomAnchor, constant: 10).isActive = true;
        
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
