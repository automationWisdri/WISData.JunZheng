//
//  UITextView+WIS.swift
//  WISData.JunZheng
//
//  Created by Allen on 16/9/4.
//  Copyright © 2016 Wisdri. All rights reserved.
//

import UIKit

// Solve the problem: Assertion failure in UITextView _firstBaselineOffsetFromTop
// Cannot debug in view hierarchy mode
// ref: http://stackoverflow.com/questions/37068231/assertion-failure-in-uitextview-firstbaselineoffsetfromtop

extension UITextView {
    
    func _firstBaselineOffsetFromTop() {
    }
    
    func _baselineOffsetFromBottom() {
    }
    
}