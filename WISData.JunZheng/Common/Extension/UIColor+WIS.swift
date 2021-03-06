//
//  UIColor+WIS.swift
//  WISData.JunZheng
//
//  Created by Allen on 5/3/16.
//  Copyright © 2016 Wisdri. All rights reserved.
//

import UIKit

func createImageWithColor(color:UIColor) -> UIImage{
    return createImageWithColor(color, size: CGSizeMake(1, 1))
}

func createImageWithColor(color:UIColor,size:CGSize) -> UIImage {
    let rect = CGRectMake(0, 0, size.width, size.height)
    UIGraphicsBeginImageContext(rect.size);
    let context = UIGraphicsGetCurrentContext()!;
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    
    let theImage = UIGraphicsGetImageFromCurrentImageContext()!;
    UIGraphicsEndImageContext();
    return theImage;
}

extension UIColor {
    
    class func globalDefaultTintColor() -> UIColor {
        return UIColor(red: 2/255.0, green: 146/255.0, blue: 255/255.0, alpha: 1.0)
    }
    
    class func wisLogoColor() -> UIColor {
        return UIColor(red: 47/255.0, green: 89/255.0, blue: 171/255.0, alpha: 1.0)
    }
    
    class func wisTintColor() -> UIColor {
        return UIColor(red: 50/255.0, green: 167/255.0, blue: 255/255.0, alpha: 1.0)
    }
    
    class func wisMessageColor() -> UIColor {
        return UIColor(red: 64/255.0, green: 64/255.0, blue: 64/255.0, alpha: 1.0)
    }

    class func wisNavgationBarTitleColor() -> UIColor {
        return UIColor(red: 0.247, green: 0.247, blue: 0.247, alpha: 1.0)
    }

    class func wisViewBackgroundColor() -> UIColor {
        return UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1.0)
    }

    class func wisInputTextColor() -> UIColor {
        return UIColor(red: 0.557, green: 0.557, blue: 0.576, alpha: 1.0)
    }

    class func wisMessageToolbarSubviewBorderColor() -> UIColor {
        return UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0)
    }

    class func wisBorderColor() -> UIColor {
        return UIColor(red: 0.898, green: 0.898, blue: 0.898, alpha: 1)
    }

    class func avatarBackgroundColor() -> UIColor {
        return UIColor(red: 50/255.0, green: 167/255.0, blue: 255/255.0, alpha: 0.3)
    }
    
    class func messageToolBarColor() -> UIColor {
        return UIColor(red:0.557, green:0.557, blue:0.576, alpha:1)
    }

    class func messageToolBarHighlightColor() -> UIColor {
        return UIColor.wisTintColor()
    }

    class func messageToolBarNormalColor() -> UIColor {
        return UIColor.lightGrayColor()
    }
    
    class func wisDisabledColor() -> UIColor {
        return UIColor(red:0.95, green:0.95, blue:0.95, alpha:1)
    }
    
    class func wisGrayColor() -> UIColor {
        return UIColor(red: 142.0/255.0, green: 142.0/255.0, blue: 147.0/255.0, alpha: 1.0)
    }
    
    class func wisBackgroundColor() -> UIColor {
        return UIColor(red: 250/255.0, green: 250/255.0, blue: 250/255.0, alpha: 1.0)
    }

    class func wisCellSeparatorColor() -> UIColor {
        return UIColor.lightGrayColor().colorWithAlphaComponent(0.3)
    }
    
    class func wisGroupHeaderColor() -> UIColor {
        return UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 0.85)
    }

    class func wisCellAccessoryImageViewTintColor() -> UIColor {
        return UIColor.lightGrayColor()
    }

    class func wisIconImageViewTintColor() -> UIColor {
        return wisCellAccessoryImageViewTintColor()
    }

    // 反色
    var wis_inverseColor: UIColor {

        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)

        return UIColor(red: 1 - red, green: 1 - green, blue: 1 - blue, alpha: alpha)
    }

    // 黑白色
    var wis_binaryColor: UIColor {

        var white: CGFloat = 0
        getWhite(&white, alpha: nil)

        return white > 0.92 ? UIColor.blackColor() : UIColor.whiteColor()
    }

    var wis_profilePrettyColor: UIColor {
        //return wis_inverseColor
        return wis_binaryColor
    }
}
