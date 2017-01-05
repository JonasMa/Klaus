//
//  ItemCollectionViewController.swift
//  Klaus
//
//  Created by Alex Knittel on 19.12.16.
//  Copyright © 2016 Nimm Swag. All rights reserved.
//

import UIKit


class ItemCollectionViewController: UICollectionViewController {
    
    var flowLayout:UICollectionViewFlowLayout!;
    var profile: Profile!;

    
    
    override func loadView() {
        flowLayout = UICollectionViewFlowLayout()
        self.collectionView = ItemCollectionView(frame: CGRect(), collectionViewLayout: flowLayout as UICollectionViewLayout);
    }
    

    override func viewDidLoad() {
        super.viewDidLoad();
        
        self.collectionView!.translatesAutoresizingMaskIntoConstraints = false;
        self.collectionView!.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0);
        self.collectionView!.layer.shadowColor = Style.vermillion.cgColor;
        self.collectionView!.layer.shadowOpacity = 0.9;
        self.collectionView!.layer.shadowRadius = 2;

        let margin = view.frame.size.width*0.05;
        let widthPerItem = view.frame.size.width*0.40;
        let heightperItem = view.frame.size.width*0.40;
        
        flowLayout.sectionInset = UIEdgeInsetsMake(margin, margin, margin, margin);
        flowLayout.minimumLineSpacing = margin;
        flowLayout.itemSize = CGSize(width: widthPerItem, height: heightperItem);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}
