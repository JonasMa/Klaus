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
    var nameTextField: UITextField!;
    var pageIndex = 2;
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = Style.bg;

        nameLabel = UILabel();
        nameLabel.text = "Tippe unten auf Okay, um fortzufahren!";
        nameLabel.textAlignment = .center;
        nameLabel.translatesAutoresizingMaskIntoConstraints = false;
        self.view.addSubview(nameLabel);
        
        dismissButton = UIButton(type: UIButtonType.roundedRect);
        dismissButton.setTitle("Okay", for: .normal);
        dismissButton.translatesAutoresizingMaskIntoConstraints = false;
        dismissButton.tintColor = Style.accentColor;
        self.view.addSubview(dismissButton);
        dismissButton.addTarget(self, action: #selector(dismissTutorial), for: .touchDown)
        
        addConstraints()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func addConstraints(){
        nameLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true;
        nameLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -40).isActive = true;
        dismissButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true;
        dismissButton.bottomAnchor.constraint(equalTo: self.bottomLayoutGuide.topAnchor).isActive = true;
        
    }
    
    func dismissTutorial(){
        self.presentingViewController?.dismiss(animated: true, completion: nil);
    }


}
