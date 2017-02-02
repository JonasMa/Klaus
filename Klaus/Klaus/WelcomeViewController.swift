//
//  WelcomeViewController.swift
//  Klaus
//
//  Created by admin on 01.02.17.
//  Copyright © 2017 Nimm Swag. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {

    var klausIcon: UIImageView!
    var welcomeTitle: UILabel!
    var klausExplanation: UILabel!
    var nextButton: UIButton!
    var buttonGradient: CAGradientLayer!
    var pageIndex = 1
    
    override func viewDidLoad(){
        super.viewDidLoad()
        self.view.backgroundColor = Style.bg;

        klausIcon = UIImageView(frame: CGRect(x: UIScreen.main.bounds.width*0.05, y: UIScreen.main.bounds.width*0.05, width: UIScreen.main.bounds.width*0.2, height: UIScreen.main.bounds.width*0.2))
        klausIcon.contentMode = UIViewContentMode.scaleAspectFit;
        klausIcon.image = UIImage(named: "klaus_big")
        klausIcon.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(klausIcon)
        
        welcomeTitle = UILabel()
        welcomeTitle.text = Strings.welcomeTitleText
        welcomeTitle.textColor = Style.accentColor
        welcomeTitle.font = Style.titleTextFont
        welcomeTitle.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(welcomeTitle)
        
        klausExplanation = UILabel()
        klausExplanation.text = Strings.welcomeExplanationText
        klausExplanation.font = Style.bodyTextFont
        klausExplanation.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(klausExplanation)
        
        nextButton = Style.getPrimaryButton(buttonTitle: Strings.tutorialButtonText)
        buttonGradient = Style.primaryButtonBackgroundGradient()
        nextButton.layer.insertSublayer(buttonGradient, at: 0);
        self.view.addSubview(nextButton)
        nextButton.addTarget(self, action: #selector(nextButtonPressed), for: .touchDown)

        addContraints()
    }
    
    func nextButtonPressed() {
        NotificationCenter.default.post(name: NotificationCenterKeys.setTutorialPageViewController, object: nil, userInfo: ["pageIndex":pageIndex] )
    }
    
    override func viewDidLayoutSubviews() {
        buttonGradient.frame = nextButton.bounds;
    }
    
    func addContraints() {
        klausIcon.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        klausIcon.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -150).isActive = true
        
        welcomeTitle.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        welcomeTitle.topAnchor.constraint(equalTo: klausIcon.bottomAnchor, constant: 30).isActive = true
        welcomeTitle.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true
        welcomeTitle.textAlignment = .center
        
        klausExplanation.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        klausExplanation.topAnchor.constraint(equalTo: welcomeTitle.bottomAnchor, constant: 20).isActive = true
        klausExplanation.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true
        klausExplanation.lineBreakMode = NSLineBreakMode.byWordWrapping
        klausExplanation.numberOfLines = 10
        klausExplanation.textAlignment = .center
        
        nextButton.bottomAnchor.constraint(equalTo: self.bottomLayoutGuide.topAnchor,constant: -8).isActive = true
        nextButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 8).isActive = true
        nextButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -8).isActive = true
    }
}
