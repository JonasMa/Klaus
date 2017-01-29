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
    
    var buttonRed: UIButton!
    var buttonBlue: UIButton!
    var buttonGreen: UIButton!
    var buttonYellow: UIButton!
    
    var pageIndex = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = Style.bg;
        
        headLineColor = UILabel()
        headLineColor.text = Strings.headLineColorText
        headLineColor.textAlignment = .center;
        headLineColor.translatesAutoresizingMaskIntoConstraints = false;
        self.view.addSubview(headLineColor);
        
        descriptionColor = UILabel()
//        descriptionColor.numberOfLines = 3
//        descriptionColor.lineBreakMode = .byWordWrapping
        descriptionColor.text = Strings.descritpionColorText
        descriptionColor.textAlignment = .center;
        descriptionColor.translatesAutoresizingMaskIntoConstraints = false;
        self.view.addSubview(descriptionColor);
        
        endTutorialButton = UIButton(type: UIButtonType.roundedRect);
        endTutorialButton.setTitle(Strings.tutorialEndText, for: .normal);
        endTutorialButton.translatesAutoresizingMaskIntoConstraints = false;
        endTutorialButton.tintColor = Style.accentColor;
        self.view.addSubview(endTutorialButton);
        endTutorialButton.addTarget(self, action: #selector(dismissTutorial), for: .touchDown)
        
        
        buttonRed = UIButton()
        buttonRed.setTitle(Strings.colorRedText, for: .normal)
        buttonRed.backgroundColor = Style.colorRed
        self.view.addSubview(buttonRed)
        addButtonConstraint(button: buttonRed, influencedObject: descriptionColor)

        buttonBlue = UIButton()
        buttonBlue.setTitle(Strings.colorBlueText, for: .normal);
        buttonBlue.backgroundColor = Style.colorBlue;
        self.view.addSubview(buttonBlue);
        addButtonConstraint(button: buttonBlue, influencedObject: buttonRed)
        
        buttonYellow = UIButton()
        buttonYellow.setTitle(Strings.colorYellowText, for: .normal);
        buttonYellow.translatesAutoresizingMaskIntoConstraints = false;
        buttonYellow.backgroundColor = Style.colorYellow;
        self.view.addSubview(buttonYellow);
        addButtonConstraint(button: buttonYellow, influencedObject: buttonBlue)
        
        buttonGreen = UIButton()
        buttonGreen.setTitle(Strings.colorGreenText, for: .normal);
        buttonGreen.translatesAutoresizingMaskIntoConstraints = false;
        buttonGreen.backgroundColor = Style.colorGreen;
        self.view.addSubview(buttonGreen);
        addButtonConstraint(button: buttonGreen, influencedObject: buttonYellow)
        
        addConstraints()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
//        descriptionColor.sizeToFit()
//        descriptionColor.heightAnchor.constraint(equalToConstant: 100.0)
        
        endTutorialButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true;
        endTutorialButton.bottomAnchor.constraint(equalTo: self.bottomLayoutGuide.topAnchor).isActive = true;
    }
    
    func selectPlayerColor(sender: UIButton) {
        colorSelected = true
        AppModel.sharedInstance.player.setColor(color: sender.backgroundColor!)
        sender.backgroundColor = sender.backgroundColor?.darker(by: 30)
        switch sender {
        case buttonRed: buttonBlue.backgroundColor = Style.colorBlue; buttonYellow.backgroundColor = Style.colorYellow; buttonGreen.backgroundColor = Style.colorGreen
            case buttonBlue: buttonRed.backgroundColor = Style.colorRed; buttonYellow.backgroundColor = Style.colorYellow; buttonGreen.backgroundColor = Style.colorGreen
        case buttonYellow: buttonBlue.backgroundColor = Style.colorBlue; buttonRed.backgroundColor = Style.colorRed; buttonGreen.backgroundColor = Style.colorGreen
        case buttonGreen: buttonBlue.backgroundColor = Style.colorBlue; buttonYellow.backgroundColor = Style.colorYellow; buttonRed.backgroundColor = Style.colorRed
            default: break
        }
    }
    
    func dismissTutorial(){
        if colorSelected {
            self.presentingViewController?.dismiss(animated: true, completion: nil);
        }
    }
    
    
}

