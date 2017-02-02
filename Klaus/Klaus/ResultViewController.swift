//
//  ResultViewController.swift
//  Klaus
//
//  Created by Oliver Pieper on 29.12.16.
//  Copyright © 2016 Nimm Swag. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {
    var descriptionLabel: UILabel!
    var titleLabel: UILabel!
    var backButton: UIButton!
    var buttonGradient: CAGradientLayer!
    
    let axe = 0
    let simon = 1
    let shelf = 2
    let seitenschneider = 3
    
    var result: Double = 0.0
    var resultAsString: String!
    var gameID: Int!

    init(result: Double, gameID: Int){
        super.init(nibName: "ResultViewController", bundle: nil)
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.result = round(10000 * result) / 10000
        handleScore()
        self.resultAsString = String(format: "%g", self.result)
        self.gameID = gameID
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backButton = Style.getPrimaryButton(buttonTitle: Strings.tutorialButtonText)
        buttonGradient = Style.primaryButtonBackgroundGradient()
        backButton.layer.insertSublayer(buttonGradient, at: 0);
        self.view.addSubview(backButton)
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchDown)
        backButton.bottomAnchor.constraint(equalTo: self.bottomLayoutGuide.topAnchor,constant: -8).isActive = true
        backButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 8).isActive = true
        backButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -8).isActive = true
        
        titleLabel = UILabel()
        titleLabel.font = Style.titleTextFont
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(titleLabel)
        titleLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -130).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true
        titleLabel.textAlignment = .center

        descriptionLabel = UILabel()
        descriptionLabel.font = Style.titleTextFont
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(descriptionLabel)
        descriptionLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -100).isActive = true
        descriptionLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true
        descriptionLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        descriptionLabel.numberOfLines = 5
        descriptionLabel.textAlignment = .center
        
        setLabels()
    }
    
    func backButtonPressed() {
        _ = navigationController?.popToRootViewController(animated: true)
    }
    
    func handleScore() {
        AppModel.sharedInstance.pushPersonalScore(score: self.result)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLayoutSubviews() {
        buttonGradient.frame = backButton.bounds;
    }
    
    func setLabels() {
        switch gameID {
        case axe:
            titleLabel.text = Strings.axeGameTitle
            descriptionLabel.text = Strings.axeGameResult + resultAsString
            break
        case simon:
            titleLabel.text = Strings.simonSaysTitle
            descriptionLabel.text = Strings.simonSaysResultPt1 + resultAsString + Strings.simonSaysResultPt2
            break
        case shelf:
            titleLabel.text = Strings.shelfGameTitle
            descriptionLabel.text = Strings.shelfGameResultPt1 + resultAsString + Strings.shelfGameResultPt2
            break
        case seitenschneider:
            titleLabel.text = Strings.seitenschneiderTitle
            descriptionLabel.text = Strings.seitenschneiderResultPt1 + resultAsString + Strings.seitenschneiderResultPt2
            break
        default:
            break
        }
    }
}
