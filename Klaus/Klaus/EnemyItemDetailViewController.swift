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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //STEAL BUTTON
        stealButton = UIButton(type: UIButtonType.roundedRect);
        stealButton.tintColor = Style.accentColor;
        stealButton.translatesAutoresizingMaskIntoConstraints = false;
        stealButton.setTitle("STEAL ITEM", for: .normal);
        stealButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        self.view.addSubview(stealButton);
    
        self.title = "Details";
        
        //CONSTRAINTS
        stealButton.topAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0).isActive = true;
        stealButton.bottomAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 40).isActive = true;
        stealButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true;
        stealButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func buttonAction(sender: UIButton!) {
        let vc = ExplanationViewController(item: item);
        navigationController?.pushViewController(vc, animated: true)
        AppModel.sharedInstance.triggerEnemyGameInstance(stolenItem: item)
    }
}
