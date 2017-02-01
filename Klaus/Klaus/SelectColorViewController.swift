//
//  SelectColorViewController.swift
//  Klaus
//
//  Created by admin on 27.01.17.
//  Copyright © 2017 Nimm Swag. All rights reserved.
//

import UIKit

class SelectColorViewController: UIViewController {
    
    var colorSelected = false
    var headLineColor: UILabel!
    var descriptionColor: UILabel!
    
    var endTutorialButton: UIButton!
    var buttonGradient: CAGradientLayer!
    
    var buttonRed: UIButton!
    var buttonBlue: UIButton!
    var buttonGreen: UIButton!
    var buttonYellow: UIButton!
    
    var pageIndex = 3
    
    var playerColor = UIColor.black;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = Style.bg;
        
        headLineColor = UILabel()
        headLineColor.text = Strings.headLineColorText
        headLineColor.textAlignment = .center;
        headLineColor.translatesAutoresizingMaskIntoConstraints = false;
        self.view.addSubview(headLineColor);
        
        descriptionColor = UILabel()
        descriptionColor.text = Strings.descritpionColorText
        descriptionColor.textAlignment = .center;
        descriptionColor.translatesAutoresizingMaskIntoConstraints = false;
        self.view.addSubview(descriptionColor);
        
        endTutorialButton = Style.getPrimaryButton(buttonTitle: Strings.tutorialEndText)
        buttonGradient = Style.primaryButtonBackgroundGradient()
        endTutorialButton.layer.insertSublayer(buttonGradient, at: 0);
        self.view.addSubview(endTutorialButton)
        endTutorialButton.addTarget(self, action: #selector(dismissTutorial), for: .touchDown)
        
        buttonRed = UIButton()
        buttonRed.setTitle(Strings.colorRedText, for: .normal)
        buttonRed.backgroundColor = Config.possibleColors[0]
        self.view.addSubview(buttonRed)
        addButtonConstraint(button: buttonRed, influencedObject: descriptionColor)

        buttonBlue = UIButton()
        buttonBlue.setTitle(Strings.colorBlueText, for: .normal);
        buttonBlue.backgroundColor = Config.possibleColors[1]
        self.view.addSubview(buttonBlue);
        addButtonConstraint(button: buttonBlue, influencedObject: buttonRed)
        
        buttonYellow = UIButton()
        buttonYellow.setTitle(Strings.colorYellowText, for: .normal);
        buttonYellow.translatesAutoresizingMaskIntoConstraints = false;
        buttonYellow.backgroundColor = Config.possibleColors[2]
        self.view.addSubview(buttonYellow);
        addButtonConstraint(button: buttonYellow, influencedObject: buttonBlue)
        
        buttonGreen = UIButton()
        buttonGreen.setTitle(Strings.colorGreenText, for: .normal);
        buttonGreen.translatesAutoresizingMaskIntoConstraints = false;
        buttonGreen.backgroundColor = Config.possibleColors[3]
        self.view.addSubview(buttonGreen);
        addButtonConstraint(button: buttonGreen, influencedObject: buttonYellow)
        
        addConstraints()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLayoutSubviews() {
        buttonGradient.frame = endTutorialButton.bounds;
    }
    
    func addButtonConstraint(button: UIButton, influencedObject: UIView){
        button.translatesAutoresizingMaskIntoConstraints = false
        let leftConstraint = NSLayoutConstraint(item: button, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1.0, constant: 10)
        let rightConstraint = NSLayoutConstraint(item: button, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1.0, constant: -10)
        let topConstraint = NSLayoutConstraint(item: button, attribute: .top, relatedBy: .equal, toItem: influencedObject, attribute: .bottomMargin, multiplier: 1.0, constant: 40)
        let heightConstraint = NSLayoutConstraint(item: button, attribute: .height, relatedBy: .equal, toItem: view, attribute: .height, multiplier: 0.1, constant: 0)
        view.addConstraints([leftConstraint, rightConstraint, topConstraint, heightConstraint])
        button.addTarget(self, action: #selector(selectPlayerColor(sender:)), for: .touchUpInside)
    }
    
    func addConstraints(){
        headLineColor.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 60).isActive = true;
        headLineColor.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true;
        
        descriptionColor.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true;
        descriptionColor.centerYAnchor.constraint(equalTo: headLineColor.bottomAnchor, constant: 20).isActive = true;
        descriptionColor.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true;
        //descriptionColor.topAnchor.constraint(equalTo: self.headLineColor.bottomAnchor, constant: 20).isActive = true;
        descriptionColor.lineBreakMode = NSLineBreakMode.byWordWrapping
        descriptionColor.numberOfLines = 3
        descriptionColor.textAlignment = .center

        endTutorialButton.bottomAnchor.constraint(equalTo: self.bottomLayoutGuide.topAnchor,constant: -8).isActive = true;
        endTutorialButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 8).isActive = true;
        endTutorialButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -8).isActive = true;
    }
    
    func selectPlayerColor(sender: UIButton) {
        colorSelected = true
        print("SC \(sender.backgroundColor!.toHexString())");
        switch sender {
        case buttonRed: buttonRed.backgroundColor = Config.possibleColors[0]; buttonBlue.backgroundColor = Config.possibleColors[1]; buttonYellow.backgroundColor = Config.possibleColors[2]; buttonGreen.backgroundColor = Config.possibleColors[3]
            playerColor = buttonRed.backgroundColor!
        case buttonBlue: buttonBlue.backgroundColor = Config.possibleColors[1]; buttonRed.backgroundColor = Config.possibleColors[0]; buttonYellow.backgroundColor = Config.possibleColors[2]; buttonGreen.backgroundColor = Config.possibleColors[3]
        playerColor = buttonBlue.backgroundColor!

        case buttonYellow: buttonYellow.backgroundColor = Config.possibleColors[2]; buttonBlue.backgroundColor = Config.possibleColors[1]; buttonRed.backgroundColor = Config.possibleColors[0]; buttonGreen.backgroundColor = Config.possibleColors[3]
        playerColor = buttonYellow.backgroundColor!

        case buttonGreen: buttonGreen.backgroundColor = Config.possibleColors[3]; buttonBlue.backgroundColor = Config.possibleColors[1]; buttonYellow.backgroundColor = Config.possibleColors[2]; buttonRed.backgroundColor = Config.possibleColors[0]
        playerColor = buttonGreen.backgroundColor!

        default: break
        }
        sender.backgroundColor = sender.backgroundColor?.darker(by: 30)
        AppModel.sharedInstance.player.setColor(color: self.playerColor)
    }
    
    func dismissTutorial(){
        if colorSelected {
            self.presentingViewController?.dismiss(animated: true, completion: nil);
            BluetoothController.sharedInstance.start()
        }
    }
    
    
}

