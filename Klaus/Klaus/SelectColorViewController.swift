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
    
    var pageIndex = 4
    
    var playerColor = UIColor.black;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = Style.bg;
        
        headLineColor = UILabel()
        headLineColor.text = Strings.headLineColorText
        headLineColor.textAlignment = .center;
        headLineColor.font = Style.titleTextFont;
        headLineColor.textColor = Style.primaryTextColor
        headLineColor.translatesAutoresizingMaskIntoConstraints = false;
        self.view.addSubview(headLineColor);
        
        descriptionColor = UILabel()
        descriptionColor.text = Strings.descritpionColorText
        descriptionColor.textAlignment = .center;
        descriptionColor.font = Style.bodyTextFont
        descriptionColor.textColor = Style.primaryTextColor
        descriptionColor.translatesAutoresizingMaskIntoConstraints = false;
        self.view.addSubview(descriptionColor);
        
        endTutorialButton = Style.getPrimaryButton(buttonTitle: Strings.tutorialEndText)
        buttonGradient = Style.primaryButtonBackgroundGradient()
        endTutorialButton.layer.insertSublayer(buttonGradient, at: 0);
        self.view.addSubview(endTutorialButton)
        endTutorialButton.addTarget(self, action: #selector(dismissTutorial), for: .touchDown)
        
        buttonRed = getColorButton(buttonText: Strings.colorRedText, buttonColor: Config.possibleColors[0], influencedObject: descriptionColor)
        buttonBlue = getColorButton(buttonText: Strings.colorBlueText, buttonColor: Config.possibleColors[1], influencedObject: buttonRed)
        buttonYellow = getColorButton(buttonText: Strings.colorYellowText, buttonColor: Config.possibleColors[2], influencedObject: buttonBlue)
        buttonGreen = getColorButton(buttonText: Strings.colorGreenText, buttonColor: Config.possibleColors[3], influencedObject: buttonYellow)
        
        addConstraints()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLayoutSubviews() {
        buttonGradient.frame = endTutorialButton.bounds;
    }
    
    func getColorButton(buttonText: String, buttonColor: UIColor, influencedObject: UIView) -> UIButton{
        let colorButton = UIButton()
        colorButton.setTitle(buttonText, for: .normal)
        colorButton.backgroundColor = buttonColor
        colorButton.translatesAutoresizingMaskIntoConstraints = false
        colorButton.titleLabel?.font = Style.titleTextFont;
        colorButton.titleLabel?.textColor = Style.primaryTextColor
        colorButton.layer.cornerRadius = 10
        self.view.addSubview(colorButton)
        addButtonConstraint(button: colorButton, influencedObject: influencedObject)
        return colorButton
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
        descriptionColor.lineBreakMode = NSLineBreakMode.byWordWrapping
        descriptionColor.numberOfLines = 3
        descriptionColor.textAlignment = .center

        endTutorialButton.bottomAnchor.constraint(equalTo: self.bottomLayoutGuide.topAnchor,constant: -8).isActive = true;
        endTutorialButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 8).isActive = true;
        endTutorialButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -8).isActive = true;
    }
    
    func selectPlayerColor(sender: UIButton) {
        colorSelected = true
        if Config.possibleColors.contains(sender.backgroundColor!) {
            self.playerColor = sender.backgroundColor!
            self.resetButtonColors()
            sender.backgroundColor = sender.backgroundColor?.darker(by: 30)
            AppModel.sharedInstance.player.setColor(color: self.playerColor)
        }
    }

    func resetButtonColors() {
        buttonRed.backgroundColor = Config.possibleColors[0]
        buttonBlue.backgroundColor = Config.possibleColors[1]
        buttonYellow.backgroundColor = Config.possibleColors[2]
        buttonGreen.backgroundColor = Config.possibleColors[3]
    }
    
    func dismissTutorial(){
        if colorSelected {
            self.presentingViewController?.dismiss(animated: true, completion: nil);
            BluetoothController.sharedInstance.start()
        }
    }
}

