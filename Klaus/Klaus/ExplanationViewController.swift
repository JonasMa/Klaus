//
//  ExplanationViewController.swift
//  Klaus
//
//  Created by Oliver Pieper on 29.12.16.
//  Copyright © 2016 Nimm Swag. All rights reserved.
//
//  Overall ExplanationViewController which is used by every Minigame

import UIKit

class ExplanationViewController: UIViewController {

//    @IBOutlet weak var startGameButton: UIButton!
//    @IBOutlet weak var explanationLabel: UILabel!
    var explanationLabel: UILabel!
    var explanationImage: UIImage!
    var startGameButton: UIButton!
    var buttonGradient: CAGradientLayer!
    var vc = UIViewController()
    var id: Int = 0
    var item: Item!;
    
    //Calls appropriate GameController
//    @IBAction func startButton(_ sender: UIButton) {
//        navigationController?.pushViewController(vc, animated: true)
//    }
    
    init(item: Item){
        super.init(nibName: "ExplanationViewController", bundle: nil)
        self.item = item;
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: false)
 

        startGameButton = Style.getPrimaryButton(buttonTitle: "Auf zum Spiel")
        buttonGradient = Style.primaryButtonBackgroundGradient()
        startGameButton.layer.insertSublayer(buttonGradient, at: 0);
        self.view.addSubview(startGameButton)
        startGameButton.addTarget(self, action: #selector(startGame), for: .touchUpInside)
        startGameButton.bottomAnchor.constraint(equalTo: self.bottomLayoutGuide.topAnchor,constant: -8).isActive = true
        startGameButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 8).isActive = true
        startGameButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -8).isActive = true
        
        explanationLabel = UILabel()
        delegateGameController()
        explanationLabel.font = Style.titleTextFont
        explanationLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(explanationLabel)
        explanationLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        explanationLabel.topAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -100).isActive = true
        explanationLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true
        explanationLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        explanationLabel.numberOfLines = 5
        explanationLabel.textAlignment = .center
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.hidesBottomBarWhenPushed = true
    }
    
    override func viewDidLayoutSubviews() {
        buttonGradient.frame = startGameButton.bounds;
    }
    
    func startGame() {
        navigationController?.pushViewController(vc, animated: true)
    }
    
    //TODO: attach appropriate GameControllers and Explanation Strings
    func delegateGameController() -> Void {
        explanationLabel.text = item.getGameExplanation();
        vc = item.getAssociatedGameViewController();
    }

}
