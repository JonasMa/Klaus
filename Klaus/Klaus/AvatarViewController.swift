//
//  AvatarViewController.swift
//  Klaus
//
//  Created by Alex Knittel on 21.01.17.
//  Copyright © 2017 Nimm Swag. All rights reserved.
//

import UIKit

class AvatarViewController: UIViewController {

    var dismissButton:UIButton! = UIButton(type: .custom);
    var nameLabel: UILabel!;
    var swipeLabel: UILabel!;
    var pageIndex = 2;
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = Style.bg;

        nameLabel = UILabel();
        nameLabel.text = "Tippe unten auf Okay, um fortzufahren!";
        nameLabel.textAlignment = .center;
        nameLabel.translatesAutoresizingMaskIntoConstraints = false;
        self.view.addSubview(nameLabel);
        
        swipeLabel = UILabel()
        swipeLabel.text = Strings.tutorialSwipeText
        swipeLabel.textAlignment = .center
        swipeLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(swipeLabel)

        addConstraints()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func addConstraints(){
        nameLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true;
        nameLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -40).isActive = true;
        swipeLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true;
        swipeLabel.bottomAnchor.constraint(equalTo: self.bottomLayoutGuide.topAnchor).isActive = true;
    }



}
