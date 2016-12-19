//
//  PlayerItemCollectionViewCell.swift
//  Klaus
//
//  Created by Alex Knittel on 19.12.16.
//  Copyright © 2016 Nimm Swag. All rights reserved.
//

import UIKit

class PlayerItemCollectionViewCell: UICollectionViewCell {
    var imageView: UIImageView!;
    var label: UILabel!;
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        
        imageView = UIImageView(frame: CGRect(x:0, y:0, width: frame.size.width , height: frame.size.width*2/3));
        imageView.contentMode = UIViewContentMode.scaleAspectFit;
        contentView.addSubview(imageView);
        
        label = UILabel(frame: CGRect(x:0,y: imageView.frame.size.height, width: frame.size.width, height: frame.size.width/3));
        label.textAlignment = .center
        contentView.addSubview(label);
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
