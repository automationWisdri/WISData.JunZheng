//
//  UIImage+WIS.swift
//  WISData.JunZheng
//
//  Created by Allen on 16/8/26.
//  Copyright © 2016 Wisdri. All rights reserved.
//

import UIKit

extension UIImage {
    
    class func imageUsedTemplateMode(named: String) -> UIImage? {
        
        let image = UIImage(named: named)
        if image == nil {
            return nil
        }
        return image!.imageWithRenderingMode(.AlwaysTemplate)
    }
}