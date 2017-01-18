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
        super.init(style: UITableViewCellStyle.subtitle, reuseIdentifier: reuseIdentifier);
        self.textLabel?.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0);
        self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0);
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
