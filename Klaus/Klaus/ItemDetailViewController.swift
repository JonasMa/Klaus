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
    var itemDateLabel: UILabel!;
    var itemDateValue: UILabel!;
    
    var itemText: UITextView!;
    
    
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
        self.itemImageView.image = UIImage(named: item.imageName.lowercased())?.withRenderingMode(.alwaysTemplate);
        self.itemImageView.tintColor = Style.primaryTextColor;
        self.itemImageView.contentMode = UIViewContentMode.scaleAspectFit;
        self.itemImageView.translatesAutoresizingMaskIntoConstraints = false;
        self.itemImageView.layer.shadowColor = item.itemColor.cgColor;
        self.itemImageView.layer.shadowRadius = 5;
        self.itemImageView.layer.shadowOpacity = 1;
        self.itemImageView.layer.shadowOffset = CGSize(width: 0, height: 0);
        self.itemImageContainer.addSubview(itemImageView);
        
        //ITEMNAME
        self.itemNameContainer = UIView();
        self.itemNameContainer.translatesAutoresizingMaskIntoConstraints = false;
        self.view.addSubview(itemNameContainer);
        
        self.itemLevelLabel = UILabel();
        self.itemLevelLabel.text = String("Level \(item.itemLevel)");
        self.itemLevelLabel.font = Style.bodyTextFont;
        self.itemLevelLabel.textAlignment = .center;
        self.itemLevelLabel.translatesAutoresizingMaskIntoConstraints = false;
        self.itemLevelLabel.textColor = Style.primaryTextColor;
        self.itemNameContainer.addSubview(itemLevelLabel);

        self.itemNameLabel = UILabel();
        self.itemNameLabel.text = item.displayName;
        self.itemNameLabel.translatesAutoresizingMaskIntoConstraints = false;
        self.itemNameLabel.textAlignment = .center;
        self.itemNameLabel.font = Style.titleTextFont;
        self.itemNameLabel.textColor = Style.primaryTextColor;
        self.itemNameContainer.addSubview(itemNameLabel);
        
        //POINTS PER SECOND
        self.itemPointsLabel = UILabel();
        self.itemPointsLabel.text = Strings.itemPointsPerSecond;
        self.itemPointsLabel.font = Style.bodyTextFont;
        self.itemPointsLabel.translatesAutoresizingMaskIntoConstraints = false;
        self.itemPointsLabel.textAlignment = .left;
        self.itemPointsLabel.textColor = Style.primaryTextColor;
        self.view.addSubview(itemPointsLabel);
        
        self.itemPointsValue = UILabel();
        self.itemPointsValue.text = String(item.pointsPerSecond * item.itemLevel);
        self.itemPointsValue.font = Style.bodyTextFont;
        self.itemPointsValue.translatesAutoresizingMaskIntoConstraints = false;
        self.itemPointsValue.textAlignment = .right;
        self.itemPointsValue.textColor = Style.primaryTextColor;
        self.view.addSubview(itemPointsValue);
        
        //DATE
        self.itemDateLabel = UILabel();
        self.itemDateLabel.text = Strings.itemAcquisitionDate;
        self.itemDateLabel.font = Style.bodyTextFont;
        self.itemDateLabel.translatesAutoresizingMaskIntoConstraints = false;
        self.itemDateLabel.textColor = Style.primaryTextColor;
        self.itemDateLabel.textAlignment = .left;
        self.view.addSubview(itemDateLabel);
        
        self.itemDateValue = UILabel();
        self.itemDateValue.text = DateFormatter.localizedString(from: item.dateOfAcquisition, dateStyle: .medium, timeStyle: .short);
        self.itemDateValue.lineBreakMode = .byClipping
        self.itemDateValue.font = Style.bodyTextFont;
        self.itemDateValue.textAlignment = .right;
        self.itemDateValue.translatesAutoresizingMaskIntoConstraints = false;
        self.itemDateValue.textColor = Style.primaryTextColor;
        self.view.addSubview(itemDateValue);
        
        //ITEM DESCRIPTION
        self.itemText = UITextView();
        self.itemText.translatesAutoresizingMaskIntoConstraints = false;
        self.itemText.backgroundColor = UIColor.init(hue: 0, saturation: 0, brightness: 0, alpha: 0);
        self.itemText.text = item.getInfoString();
        self.itemText.textAlignment = .left;
        self.itemText.isEditable = false;
        self.itemText.textColor = Style.primaryTextColor;
        self.itemText.font = Style.smallTextFont;
        self.view.addSubview(itemText);
        
        
        
        
        
        //CONSTRAINTS
        itemImageView.topAnchor.constraint(equalTo: itemImageContainer.topAnchor, constant: 15).isActive = true;
        itemImageView.leftAnchor.constraint(equalTo: itemImageContainer.leftAnchor, constant: 15).isActive = true;
        itemImageView.bottomAnchor.constraint(equalTo: itemImageContainer.bottomAnchor, constant: -15).isActive = true;
        itemImageView.rightAnchor.constraint(equalTo: itemImageContainer.rightAnchor, constant: -15).isActive = true;
        
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
        
        itemPointsLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 8).isActive = true;
        itemPointsLabel.rightAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true;
        itemPointsLabel.topAnchor.constraint(equalTo: itemImageContainer.bottomAnchor,constant: 8).isActive = true;
        
        itemPointsValue.leftAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true;
        itemPointsValue.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -8).isActive = true;
        itemPointsValue.topAnchor.constraint(equalTo: itemImageContainer.bottomAnchor, constant: 8).isActive = true;
        
        itemDateLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 8).isActive = true;
        itemDateLabel.rightAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true;
        itemDateLabel.topAnchor.constraint(equalTo: itemPointsLabel.bottomAnchor,constant: 8).isActive = true;
        
        itemDateValue.leftAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true;
        itemDateValue.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -8).isActive = true;
        itemDateValue.topAnchor.constraint(equalTo: itemPointsValue.bottomAnchor, constant: 8).isActive = true;

        itemText.topAnchor.constraint(equalTo: self.itemDateLabel.bottomAnchor, constant: 8).isActive = true;
        itemText.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true;
        itemText.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true;
        itemText.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true;
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
