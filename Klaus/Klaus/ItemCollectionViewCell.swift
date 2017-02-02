//
//  ItemCollectionViewCell.swift
//  Klaus
//
//  Created by Alex Knittel on 19.12.16.
//  Copyright © 2016 Nimm Swag. All rights reserved.
//

import UIKit

class ItemCollectionViewCell: UICollectionViewCell {
    var imageView: UIImageView!;
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        
        
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
        imageView.contentMode = UIViewContentMode.scaleAspectFit;
        imageView.tintColor = Style.primaryTextColor;
        contentView.addSubview(imageView);
        
        self.layer.cornerRadius = 20;
        
    }
    
    func setItemShadow(color: UIColor){
        self.layer.shadowColor = color.cgColor;
        self.layer.shadowOffset = CGSize(width: 0,height: 0);
        self.layer.shadowOpacity = 0.5;
        self.layer.shadowRadius = 1;
    }
    
    func setItemBackground(color: UIColor){
        self.backgroundColor = color;
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
