//
//  EnemyTableViewCell.swift
//  Klaus
//
//  Created by Alex Knittel on 28.12.16.
//  Copyright © 2016 Nimm Swag. All rights reserved.
//

import UIKit

class EnemyTableViewCell: UITableViewCell {
    
    
    override init(style : UITableViewCellStyle, reuseIdentifier: String?){
        super.init(style: UITableViewCellStyle.value1, reuseIdentifier: reuseIdentifier);
        self.textLabel?.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0);
        self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0);
        self.textLabel?.textColor = Style.primaryTextColor;
        self.textLabel?.font = UIFont.systemFont(ofSize: 17, weight: UIFontWeightThin);
        self.detailTextLabel?.font = UIFont.systemFont(ofSize: 17, weight: UIFontWeightThin)
        self.detailTextLabel?.textColor = Style.primaryTextColor;
    
    }
    
    override func layoutSubviews() {
        super.layoutSubviews();
        var imageViewFrame = self.imageView?.frame;
        imageViewFrame?.origin.y += 5;
        imageViewFrame?.size.height -= 10;
        imageViewFrame?.size.width -= 10;
        self.imageView?.frame = imageViewFrame!;
    }
    
    func setColor(color: UIColor){
        self.imageView?.tintColor = color;
    }
    
    func setAvatar(avatar: String){
        self.imageView?.image = UIImage(named: avatar)?.withRenderingMode(.alwaysTemplate);
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
