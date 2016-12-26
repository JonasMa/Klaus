//
//  PlayerItemDetailViewController.swift
//  Klaus
//
//  Created by Alex Knittel on 26.12.16.
//  Copyright © 2016 Nimm Swag. All rights reserved.
//

import UIKit

class PlayerItemDetailViewController: UIViewController {
    
    var item:Item!;
    
    var itemImageContainer: UIView!;
    var itemImageView: UIImageView!;
    var itemNameLabel: UILabel!;
    var itemLevelLabel: UILabel!;
    var itemPointsLabel: UILabel!;
    
    override func loadView() {
        self.view = PlayerItemDetailView(frame: UIScreen.main.bounds);
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white;
        
        
        self.itemImageContainer = UIView();
        self.view.addSubview(itemImageContainer);
        self.itemImageContainer.translatesAutoresizingMaskIntoConstraints = false;
        
        self.itemImageView = UIImageView()
        self.itemImageView.image = UIImage(named: item.name.lowercased());
        self.itemImageView.contentMode = UIViewContentMode.scaleAspectFit;
        self.itemImageView.translatesAutoresizingMaskIntoConstraints = false;
        self.itemImageContainer.addSubview(itemImageView);
        
        self.itemLevelLabel = UILabel();
        self.itemLevelLabel.text = "1";//for testing
        self.itemLevelLabel.font = UIFont.boldSystemFont(ofSize: 90);
        self.itemLevelLabel.textAlignment = .center;
        self.itemLevelLabel.translatesAutoresizingMaskIntoConstraints = false;
        self.view.addSubview(itemLevelLabel);
        
//        self.itemPointsLabel = UILabel();
//        self.itemPointsLabel.text = String(item.pointsPerSecond);
//        self.itemPointsLabel.font = UIFont.systemFont(ofSize: 20);
//        self.itemPointsLabel.translatesAutoresizingMaskIntoConstraints = false;
//        self.view.addSubview(itemPointsLabel);
        
        self.itemNameLabel = UILabel();
        self.itemNameLabel.text = item.name.uppercased();
        self.itemNameLabel.translatesAutoresizingMaskIntoConstraints = false;
        self.itemNameLabel.textAlignment = .center;
        self.itemNameLabel.font = UIFont.boldSystemFont(ofSize: 40.0);
        
//        self.itemNameLabel.layer.shadowRadius = 5;
//        self.itemNameLabel.layer.shadowOffset = CGSize(width: 0, height: 0)
//        self.itemNameLabel.layer.shadowOpacity = 0.5
        self.view.addSubview(itemNameLabel);
        
        //--------------------------------------------------
        //CONSTRAINTS
        itemImageView.topAnchor.constraint(equalTo: itemImageContainer.topAnchor, constant: 30).isActive = true;
        itemImageView.leftAnchor.constraint(equalTo: itemImageContainer.leftAnchor, constant: 30).isActive = true;
        itemImageView.bottomAnchor.constraint(equalTo: itemImageContainer.bottomAnchor, constant: -30).isActive = true;
        itemImageView.rightAnchor.constraint(equalTo: itemImageContainer.rightAnchor, constant: -30).isActive = true;
        
        
        //TODO simplify constraints
        let imageTopConstraint = NSLayoutConstraint(item: itemImageContainer, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 20);
        let imageHeightConstraint = NSLayoutConstraint(item: itemImageContainer, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: itemImageContainer, attribute: NSLayoutAttribute.width, multiplier: 1, constant: 0);
        let imageLeftConstraint = NSLayoutConstraint(item: itemImageContainer, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.left, multiplier: 1, constant: 0);
        let imageWidthConstraint = NSLayoutConstraint(item: itemImageContainer, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.width, multiplier: 0.5, constant: 0);
        NSLayoutConstraint.activate([imageTopConstraint,imageHeightConstraint,imageLeftConstraint,imageWidthConstraint]);
        
        let levelTopConstraint = NSLayoutConstraint(item: itemLevelLabel, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: itemImageContainer, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0);
        let levelBottomConstraint = NSLayoutConstraint(item: itemLevelLabel, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: itemImageContainer, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0);
        let levelLeftConstraint = NSLayoutConstraint(item: itemLevelLabel, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: itemImageContainer, attribute: NSLayoutAttribute.right, multiplier: 1, constant: 0);
        let levelRightConstraint = NSLayoutConstraint(item: itemLevelLabel, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.right, multiplier: 1, constant: 0);
        
        NSLayoutConstraint.activate([levelTopConstraint,levelLeftConstraint,levelRightConstraint,levelBottomConstraint]);
        
        
        
        let namePosXConstraint = NSLayoutConstraint(item: itemNameLabel, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0);
        let namePosYConstraint = NSLayoutConstraint(item: itemNameLabel, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: itemImageContainer, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0);
        
        NSLayoutConstraint.activate([namePosXConstraint,namePosYConstraint]);
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
