//
//  EnemyItemDetailViewController.swift
//  Klaus
//
//  Created by Alex Knittel on 28.12.16.
//  Copyright © 2016 Nimm Swag. All rights reserved.
//

import UIKit

class EnemyItemDetailViewController: ItemDetailViewController {
    
    var stealButton: UIButton!;
    var enemyUuid: String?
    private var timer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //STEAL BUTTON
        stealButton = UIButton(type: UIButtonType.roundedRect);
        stealButton.translatesAutoresizingMaskIntoConstraints = false;
        stealButton.setTitle(Strings.stealButtonText, for: .normal);
        stealButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        stealButton.titleLabel?.font = Style.titleTextFont
        stealButton.tintColor = Style.primaryButtonTextColor
        stealButton.backgroundColor = item.itemColor;
        stealButton.layer.cornerRadius = 10;

        self.view.addSubview(stealButton);
    
        self.title = "Details";
        
        NotificationCenter.default.addObserver(forName: NotificationCenterKeys.startGame, object: nil, queue: nil, using: startExplanationView)
        
        //CONSTRAINTS
        stealButton.bottomAnchor.constraint(equalTo: self.bottomLayoutGuide.topAnchor,constant: -8).isActive = true;
        
        stealButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 8).isActive = true;
        stealButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -8).isActive = true;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func buttonAction(sender: UIButton!) {
        if enemyUuid == nil {
            print("ERROR: enemyUuid is nil in EnemyItemDetailViewController.buttonAction()")
            return
        }
        disableStealButton()
        AppModel.sharedInstance.triggerEnemyGameInstance(stolenItem: item, onPlayerUuuidString: enemyUuid!)
        timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(onTriggerGameTimeout), userInfo: nil, repeats: false)
    }
    
    func onAbortTriggerGameTimeout (){
        if timer != nil {
            timer!.invalidate()
            timer = nil
        }
    }
    
    @objc func onTriggerGameTimeout() {
        AppModel.sharedInstance.displayAlert(title: Strings.statusNotOkTitle, message: Strings.statusConnectionFail, buttonTitle: Strings.statusConnectionFailButton)
        onAbortTriggerGameTimeout()
        enableStealButton()
    }
    
    func startExplanationView(notification: Notification) {
        onAbortTriggerGameTimeout()
        AppModel.sharedInstance.attackedItem = item
        AppModel.sharedInstance.isAttacking = true
        let vc = ExplanationViewController(item: item);
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func disableStealButton(){
        stealButton.isEnabled = false;
        stealButton.backgroundColor = Style.lines;
    }
    
    func enableStealButton(){
        stealButton.isEnabled = true;
        stealButton.backgroundColor = item.itemColor;
    }
}
