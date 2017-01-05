//
//  EnemyItemCollectionViewController.swift
//  Klaus
//
//  Created by Alex Knittel on 28.12.16.
//  Copyright © 2016 Nimm Swag. All rights reserved.
//

import UIKit

private let reuseIdentifier = "EnemyItemCell";

class EnemyItemCollectionViewController: ItemCollectionViewController {

    
    override func loadView() {
        super.loadView();
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        self.collectionView!.register(EnemyItemCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning();
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return profile.items.count;
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! EnemyItemCollectionViewCell;
        let item = profile.items[indexPath.row];
        let name = item.name;
        cell.imageView.image = UIImage(named: name.lowercased())?.withRenderingMode(.alwaysTemplate);
        cell.label.text = name;
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailViewController = EnemyItemDetailViewController();
        detailViewController.item = profile.items[indexPath.row];
        self.navigationController?.pushViewController(detailViewController, animated: true);
    }

}
