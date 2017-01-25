//
//  Style.swift
//  Klaus
//
//  Created by Alex Knittel on 26.12.16.
//  Copyright © 2016 Nimm Swag. All rights reserved.
//

import UIKit

struct Style{

    static var primaryTextColor = UIColor(red: 33.0/255.0, green: 33.0/255.0, blue: 33.0/255.0, alpha: 1);
    static var secondaryTextColor = UIColor(red: 158.0/255.0, green: 158.0/255.0, blue: 158.0/255.0, alpha: 1);
    
    //static var gradientTop = UIColor(red: 82.0/255.0, green: 237.0/255.0, blue: 199.0/255.0, alpha: 1);
    //static var gradientBottom = UIColor(red: 90.0/255.0, green: 200.0/255.0, blue: 251.0/255.0, alpha: 1);
    
    static var bg = UIColor(red: 242.0/255.0, green: 242.0/255.0, blue: 242.0/255.0, alpha: 1);
    static var bgTransparent = UIColor(red: 242.0/255.0, green: 242.0/255.0, blue: 242.0/255.0, alpha: 0.0);
    static var accentColor = UIColor(red: 52.0/255.0, green: 170.0/255.0, blue: 220.0/255.0, alpha: 1);

    
    //GRADIENT
    static var gradientColors = [Style.bg.cgColor, Style.bg.cgColor, UIColor.lightGray.cgColor,Style.bgTransparent.cgColor, Style.bgTransparent.cgColor];
    
    static func gradientLocations() -> [NSNumber]{
        let loc = 0.37;
        return [0.0,NSNumber(floatLiteral: loc), NSNumber(floatLiteral: loc + 0.000000001), NSNumber(floatLiteral: loc + 0.05), NSNumber(floatLiteral: loc + 0.0500000001),1.0]
        
        
    }
}
