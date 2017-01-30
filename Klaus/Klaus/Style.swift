//
//  Style.swift
//  Klaus
//
//  Created by Alex Knittel on 26.12.16.
//  Copyright © 2016 Nimm Swag. All rights reserved.
//

import UIKit

struct Style{

    static var buttonFontSize:CGFloat = 44
    static var primaryButtonTextColor = UIColor.white
    
    
    static var primaryTextColor = UIColor(red: 33.0/255.0, green: 33.0/255.0, blue: 33.0/255.0, alpha: 1);
    static var secondaryTextColor = UIColor(red: 158.0/255.0, green: 158.0/255.0, blue: 158.0/255.0, alpha: 1);
    
    //static var gradientTop = UIColor(red: 82.0/255.0, green: 237.0/255.0, blue: 199.0/255.0, alpha: 1);
    //static var gradientBottom = UIColor(red: 90.0/255.0, green: 200.0/255.0, blue: 251.0/255.0, alpha: 1);
    
    static var bg = UIColor(red: 239.0/255.0, green: 239.0/255.0, blue: 244.0/255.0, alpha: 1);
    static var lines = UIColor(red: 206.0/255.0, green: 206.0/255.0, blue: 210.0/255.0, alpha: 1);
    
    static var bgTransparent = UIColor(red: 242.0/255.0, green: 242.0/255.0, blue: 242.0/255.0, alpha: 0.0);
    static var accentColor = UIColor(red: 52.0/255.0, green: 170.0/255.0, blue: 220.0/255.0, alpha: 1);
    
    static var colorRed = UIColor(red:0.98, green:0.22, blue:0.22, alpha:1.0)
    static var colorBlue = UIColor(red:0.22, green:0.57, blue:0.98, alpha:1.0)
    static var colorYellow = UIColor(red:0.98, green:0.91, blue:0.22, alpha:1.0)
    static var colorGreen = UIColor(red:0.22, green:0.98, blue:0.53, alpha:1.0)

    // Primary Button Gradient
    static func primaryButtonGradient(button: UIButton) -> CAGradientLayer {
        let buttonGradient = CAGradientLayer()
        buttonGradient.frame = button.bounds
        buttonGradient.colors = [UIColor(red:0.11, green:0.38, blue:0.94, alpha:1.0).cgColor, UIColor(red: 86.0/255.0, green: 197.0/255.0, blue: 238.0/255.0, alpha: 1.0).cgColor]
        buttonGradient.locations = [0.0, 1.0]
        buttonGradient.cornerRadius = button.layer.cornerRadius
        return buttonGradient
    }
    
    // Primary Button 
    static func getPrimaryButton() -> UIButton {
        let primaryButton = UIButton()
        return primaryButton
    }
    
    //GRADIENT
    static var gradientColors = [Style.bg.cgColor,
                                 Style.bg.cgColor,
                                 Style.lines.cgColor,
                                 Style.bgTransparent.cgColor,
                                 Style.bgTransparent.cgColor];
    
    static func gradientLocations() -> [NSNumber]{
        let loc = 0.37;
        return [0.0,
                NSNumber(floatLiteral: loc),
                NSNumber(floatLiteral: loc + 0.000000001),
                NSNumber(floatLiteral: loc + 0.05),
                NSNumber(floatLiteral: loc + 0.0500000001),
                1.0];
    }
    
    
    
    static var gradientColorsAvatarView = [Style.bg.cgColor,
                                           Style.bg.cgColor,
                                           Style.lines.cgColor,
                                           Style.bgTransparent.cgColor,
                                           Style.bgTransparent.cgColor,
                                           
                                           Style.bgTransparent.cgColor,
                                           Style.lines.cgColor,
                                           Style.bg.cgColor,
                                           
                                           
                                           Style.bg.cgColor,
                                           Style.bg.cgColor]
    
    static func gradientLocationAvatarView() ->[NSNumber]{
        let locationOfGradient = 0.25
        return [0.0,
                NSNumber(floatLiteral: locationOfGradient),
                NSNumber(floatLiteral: locationOfGradient + 0.000000001),
                NSNumber(floatLiteral: locationOfGradient + 0.05),
                NSNumber(floatLiteral: locationOfGradient + 0.0500000001),
                
                NSNumber(floatLiteral: locationOfGradient + 0.4999999998),
                NSNumber(floatLiteral: locationOfGradient + 0.5499999998),
                NSNumber(floatLiteral: locationOfGradient + 0.5499999999),

                
                NSNumber(floatLiteral: locationOfGradient + 0.6),
                NSNumber(floatLiteral: locationOfGradient + 0.6000000001),
                1.0];
    }
    
    static func gradientColorsWithTopColor(color: UIColor) -> [CGColor]{
        return [color.lighter(by: 30)!.cgColor, color.lighter(by: 50)!.cgColor, Style.lines.cgColor,Style.bgTransparent.cgColor, Style.bgTransparent.cgColor]
    }
    

    
    
}
