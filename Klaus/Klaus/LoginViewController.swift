//
//  LoginViewController.swift
//  Klaus
//
//  Created by Alex Knittel on 21.01.17.
//  Copyright © 2017 Nimm Swag. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate{
    
    let dismissButton:UIButton! = UIButton(type: .custom);
    var nameLabel: UILabel!;
    var nameTextField: UITextField!;
    var pageIndex = 1;


    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.view.backgroundColor = Style.bg;
        
        nameLabel = UILabel();
        nameLabel.text = "Bitte trage hier deinen Namen ein";
        nameLabel.translatesAutoresizingMaskIntoConstraints = false;
        nameLabel.font = UIFont.systemFont(ofSize: 16)
        self.view.addSubview(nameLabel);
        
        nameTextField = UITextField();
        nameTextField.placeholder = "Dein Name";
        nameTextField.delegate = self;
        nameTextField.translatesAutoresizingMaskIntoConstraints = false;
        nameTextField.font = UIFont.systemFont(ofSize: 16);
        nameTextField.textAlignment = .center;
        self.view.addSubview(nameTextField);
        
        addConstraints()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func addConstraints(){
        nameLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true;
        nameLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -200).isActive = true;
        nameTextField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true;
        nameTextField.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -170).isActive = true;
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        AppModel.sharedInstance.player.name = textField.text!;
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        return true
    }
    
    
}
