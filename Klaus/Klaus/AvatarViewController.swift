//
//  AvatarViewController.swift
//  Klaus
//
//  Created by Alex Knittel on 21.01.17.
//  Copyright © 2017 Nimm Swag. All rights reserved.
//

import UIKit

class AvatarViewController: UIViewController {
    
    var chosenAvatar: String!
    var chooseAvatarLabel: UILabel!;
    var chooseAvatarDescriptionLabel: UILabel!;
    var swipeLabel: UILabel!;
    var pageIndex = 2;
    
    // ____
    var avatarCollectionViewControler: AvatarCollectionViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = Style.bg;
        
        //____
//        avatarCollectionViewControler = AvatarCollectionViewController()
//        avatarCollectionViewControler.avatarImages = ["Axt", "Zange"]
//        self.addChildViewController(avatarCollectionViewControler);
//        self.view.addSubview(avatarCollectionViewControler.view);
        
        chooseAvatarLabel = UILabel();
        chooseAvatarLabel.text = Strings.chooseAvatarText
        chooseAvatarLabel.textAlignment = .center;
        chooseAvatarLabel.translatesAutoresizingMaskIntoConstraints = false;
        self.view.addSubview(chooseAvatarLabel);
        
        chooseAvatarDescriptionLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50));
        chooseAvatarDescriptionLabel.text = Strings.chooseAvatarDescriptionText
        chooseAvatarDescriptionLabel.textAlignment = .center;
        chooseAvatarDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false;
        
        chooseAvatarDescriptionLabel.numberOfLines = 4
        chooseAvatarDescriptionLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        chooseAvatarLabel.sizeToFit()
        self.view.addSubview(chooseAvatarDescriptionLabel);

        swipeLabel = UILabel()
        swipeLabel.text = Strings.tutorialSwipeText
        swipeLabel.textAlignment = .center
        swipeLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(swipeLabel)

        addConstraints()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func addConstraints(){
        chooseAvatarLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 60).isActive = true;
        chooseAvatarLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true;
        
        chooseAvatarDescriptionLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true;
        chooseAvatarDescriptionLabel.centerYAnchor.constraint(equalTo: chooseAvatarLabel.bottomAnchor, constant: 20).isActive = true;
        
        swipeLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true;
        swipeLabel.bottomAnchor.constraint(equalTo: self.bottomLayoutGuide.topAnchor).isActive = true;
        
        // ____
//        avatarCollectionViewControler.collectionView?.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor).isActive = true;
//        avatarCollectionViewControler.collectionView?.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true;
//        avatarCollectionViewControler.collectionView?.bottomAnchor.constraint(equalTo: self.bottomLayoutGuide.topAnchor).isActive = true;
//        avatarCollectionViewControler.collectionView?.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true;
    }
}
