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
    
    var spinner: UIActivityIndicatorView!;
    
    override func loadView() {
        super.loadView();
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        self.collectionView!.register(EnemyItemCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier);
        
        spinner = UIActivityIndicatorView();
        self.view.addSubview(spinner);

        setLoadingView();
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning();
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count;
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! EnemyItemCollectionViewCell;
        let item = items[indexPath.row];
        cell.imageView.image = UIImage(named: item.imageName.lowercased())?.withRenderingMode(.alwaysTemplate);
        cell.setItemShadow(color: item.itemColor);
        return cell;
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailViewController = EnemyItemDetailViewController();
        detailViewController.item = items[indexPath.row];
        detailViewController.enemyUuid = enemyUuid;
       self.navigationController?.pushViewController(detailViewController, animated: true);
    }
    
    override func updateItems(notification: Notification) {
        super.updateItems(notification: notification);
        self.spinner.stopAnimating()
        self.spinner.isHidden = true;
    }
    
    private func setLoadingView(){
        spinner.translatesAutoresizingMaskIntoConstraints = false;
        spinner.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        spinner.activityIndicatorViewStyle = .gray
        spinner.startAnimating()
        spinner.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true;
        spinner.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 80).isActive = true;
        
    }

}
