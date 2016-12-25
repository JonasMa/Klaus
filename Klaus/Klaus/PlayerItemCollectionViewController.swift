//
//  PlayerItemCollectionViewController.swift
//  Klaus
//
//  Created by Alex Knittel on 19.12.16.
//  Copyright © 2016 Nimm Swag. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class PlayerItemCollectionViewController: UICollectionViewController {
    
    var player:Player = Player(name: "Horst");
    var playerItemCollectionView:PlayerItemCollectionView!;
    var flowLayout:UICollectionViewFlowLayout!;
    
    
    override func loadView() {
        flowLayout = UICollectionViewFlowLayout()
        self.collectionView = PlayerItemCollectionView(frame: CGRect(), collectionViewLayout: flowLayout as UICollectionViewLayout);
    }
    

    override func viewDidLoad() {
        super.viewDidLoad();
        
        
        self.collectionView!.backgroundColor = UIColor.white;
        self.collectionView!.translatesAutoresizingMaskIntoConstraints = false;
        
        self.collectionView!.register(PlayerItemCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        let margin = view.frame.size.width*0.01;
        flowLayout.sectionInset = UIEdgeInsetsMake(margin, margin, margin, margin);
        flowLayout.minimumLineSpacing = margin;

        let widthPerItem = view.frame.size.width*0.46;
        let heightperItem = view.frame.size.width*0.46;
        
        flowLayout.itemSize = CGSize(width: widthPerItem, height: heightperItem);
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

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return player.items.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PlayerItemCollectionViewCell
        
        let item = player.items[indexPath.row];
        let name = item.name;
        cell.imageView.image = UIImage(named: name.lowercased());
        cell.label.text = name;
        
        return cell
    }
    
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
 

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
