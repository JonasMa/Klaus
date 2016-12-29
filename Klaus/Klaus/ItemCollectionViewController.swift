//
//  PlayerItemCollectionViewController.swift
//  Klaus
//
//  Created by Alex Knittel on 19.12.16.
//  Copyright © 2016 Nimm Swag. All rights reserved.
//

import UIKit


class ItemCollectionViewController: UICollectionViewController {
    
    var player:PlayerProfile = PlayerProfile(name: "Horst");//TODO remove
    var flowLayout:UICollectionViewFlowLayout!;
    var items: Array<Item> = Array<Item>();
    
    
    override func loadView() {
        flowLayout = UICollectionViewFlowLayout()
        self.collectionView = ItemCollectionView(frame: CGRect(), collectionViewLayout: flowLayout as UICollectionViewLayout);
    }
    

    override func viewDidLoad() {
        super.viewDidLoad();
        
        
        self.collectionView!.translatesAutoresizingMaskIntoConstraints = false;
        self.collectionView!.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0);
        self.collectionView?.layer.shadowColor = Style.vermillion.cgColor;
        self.collectionView?.layer.shadowOpacity = 0.9;
        self.collectionView?.layer.shadowRadius = 2;

        let margin = view.frame.size.width*0.05;
        flowLayout.sectionInset = UIEdgeInsetsMake(margin, margin, margin, margin);
        flowLayout.minimumLineSpacing = margin;

        let widthPerItem = view.frame.size.width*0.40;
        let heightperItem = view.frame.size.width*0.40;
        
        flowLayout.itemSize = CGSize(width: widthPerItem, height: heightperItem);
    }
    
    func updateItemCollectionWith(items: Array<Item>){
        self.items = items;
        self.collectionView?.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

//    override func numberOfSections(in collectionView: UICollectionView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
//    
//    
//    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of items
//        return 0
//    }
//    
//    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "empty", for: indexPath)
//        
//        // Configure the cell
//        
//        return cell
//    }

    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailViewController = PlayerItemDetailViewController();
        detailViewController.item = player.items[indexPath.row];
        self.navigationController?.pushViewController(detailViewController, animated: true);
    }
    
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */
 

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
