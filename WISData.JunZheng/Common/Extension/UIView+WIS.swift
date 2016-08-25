//
//  UIView+WIS.swift
//  WISData.JunZheng
//
//  Created by Allen on 16/8/24.
//  Copyright © 2016 Wisdri. All rights reserved.
//

import UIKit

extension UIView {
    
    public func removeAllSubviews() {
        
        for subview in subviews {
            subview.removeFromSuperview()
        }
    }
}