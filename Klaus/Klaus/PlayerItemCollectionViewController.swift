//
//  PlayerItemCollectionViewController.swift
//  Klaus
//
//  Created by Alex Knittel on 28.12.16.
//  Copyright © 2016 Nimm Swag. All rights reserved.
//

import UIKit

private let reuseIdentifier = "PlayerItemCell"

class PlayerItemCollectionViewController: ItemCollectionViewController {

    var highlightedItem: Item?;
    
    override func loadView(){
        super.loadView();
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView!.register(PlayerItemCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        NotificationCenter.default.addObserver(self, selector: #selector(highlightItem), name: NotificationCenterKeys.highlightItemNotification, object: nil);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func highlightItem(notification: Notification){
        highlightedItem = notification.userInfo?["item"] as? Item;
    }

    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PlayerItemCollectionViewCell
        
        let item = items[indexPath.row];
        let name = item.displayName;
        cell.imageView.image = UIImage(named: item.imageName.lowercased())?.withRenderingMode(.alwaysTemplate);
        cell.label.text = name;
        cell.setItemShadow(color: item.itemColor);
        if(item == highlightedItem){
            print("cell highlight")
            cell.highlight();
            highlightedItem = nil;
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let cell = cell as! PlayerItemCollectionViewCell;
        cell.unhighlight();
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailViewController = PlayerItemDetailViewController();
        detailViewController.item = items[indexPath.row];
        self.navigationController?.pushViewController(detailViewController, animated: true);
    }

}
