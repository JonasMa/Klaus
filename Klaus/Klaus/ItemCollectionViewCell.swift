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
    var label: UILabel!;
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        
        imageView = UIImageView(frame: CGRect(x: 0, y: frame.size.height/5, width: frame.size.width , height: frame.size.width*2/5));
        imageView.contentMode = UIViewContentMode.scaleAspectFit;
        imageView.tintColor = Style.clean;
        contentView.addSubview(imageView);
        
        label = UILabel(frame: CGRect(x:0,y: imageView.frame.size.height*5/3, width: frame.size.width, height: frame.size.width/5));
        label.textAlignment = .center
        label.textColor = Style.clean;
        contentView.addSubview(label);
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
