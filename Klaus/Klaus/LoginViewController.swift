//
//  LoginViewController.swift
//  Klaus
//
//  Created by Alex Knittel on 21.01.17.
//  Copyright © 2017 Nimm Swag. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate{
    
    var nextButton: UIButton!
    var buttonGradient: CAGradientLayer!
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
        nameTextField.becomeFirstResponder()
        
        nextButton = Style.getPrimaryButton(buttonTitle: Strings.tutorialButtonText)
        buttonGradient = Style.primaryButtonBackgroundGradient()
        nextButton.layer.insertSublayer(buttonGradient, at: 0);
        
        self.view.addSubview(nextButton)
        nextButton.addTarget(self, action: #selector(nextButtonPressed), for: .touchDown)

        addConstraints()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLayoutSubviews() {
        buttonGradient.frame = nextButton.bounds;
    }
    
    func nextButtonPressed() {
        if nameTextField.text != "" {
            NotificationCenter.default.post(name: NotificationCenterKeys.setTutorialPageViewController, object: nil, userInfo: ["pageIndex":pageIndex] )
        }
    }
    
    func addConstraints(){
        nameLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true;
        nameLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -200).isActive = true;
        
        nameTextField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true;
        nameTextField.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -170).isActive = true;
        nameTextField.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.3).isActive = true

        nameTextField.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 8).isActive = true;
        nameTextField.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -8).isActive = true;
        
        nextButton.bottomAnchor.constraint(equalTo: self.bottomLayoutGuide.topAnchor,constant: -8).isActive = true;
        nextButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 8).isActive = true;
        nextButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -8).isActive = true;
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        AppModel.sharedInstance.player.name = textField.text!;
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let limitTextLength = 8
        
        let newLength = text.characters.count + string.characters.count - range.length
        return newLength <= limitTextLength
    }
}
