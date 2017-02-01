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
    var items: Array<Item>!;
    var enemyUuid: String?

    fileprivate let itemsPerRow: CGFloat = 3;
    fileprivate let sectionInsets = UIEdgeInsets(top: UIScreen.main.bounds.height/5, left: 15.0, bottom: 0.0, right: 15.0)

    
    override func loadView() {
        flowLayout = UICollectionViewFlowLayout()
        self.collectionView = ItemCollectionView(frame: CGRect(), collectionViewLayout: flowLayout as UICollectionViewLayout);
    }
    

    override func viewDidLoad() {
        super.viewDidLoad();

        

        
        self.collectionView!.translatesAutoresizingMaskIntoConstraints = false;
        self.collectionView!.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func updateItems(notification: Notification){
        items = Array(notification.userInfo!.values) as? Array<Item>;
        self.collectionView?.reloadData();
    }

}

extension ItemCollectionViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets;
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
}
