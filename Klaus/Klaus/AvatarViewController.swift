//
//  AvatarViewController.swift
//  Klaus
//
//  Created by Alex Knittel on 21.01.17.
//  Copyright © 2017 Nimm Swag. All rights reserved.
//

import UIKit

class AvatarViewController: UIViewController {

    let dismissButton:UIButton! = UIButton(type: .custom);
    var nameLabel: UILabel!;
    var nameTextField: UITextField!;
    var pageIndex = 2;
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = Style.bg;

        nameLabel = UILabel();
        nameLabel.text = "Wähle einen Avatar";
        nameLabel.translatesAutoresizingMaskIntoConstraints = false;
        self.view.addSubview(nameLabel);
        
        //        nameTextField = UITextField();
        //        nameTextField.placeholder = "Dein Name";
        //        nameTextField.translatesAutoresizingMaskIntoConstraints = false;
        //        self.view.addSubview(nameTextField);
        
        addConstraints()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func addConstraints(){
        nameLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true;
        nameLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -40).isActive = true;
        //        nameTextField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true;
        //        nameTextField.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true;
    }


}
