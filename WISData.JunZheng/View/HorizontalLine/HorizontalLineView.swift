//
//  HorizontalLineView.swift
//  WISData.JunZheng
//
//  Created by Allen on 16/8/30.
//  Copyright © 2016 Wisdri. All rights reserved.
//

import UIKit

@IBDesignable
class HorizontalLineView: UIView {

    @IBInspectable
    var lineColor: UIColor = UIColor.wisBorderColor() {
        didSet {
            setNeedsDisplay()
        }
    }
    @IBInspectable
    var lineWidth: CGFloat = 1.0 / UIScreen.mainScreen().scale {
        didSet {
            setNeedsDisplay()
        }
    }

    @IBInspectable
    var leftMargin: CGFloat = 0 {
        didSet {
            setNeedsDisplay()
        }
    }

    @IBInspectable
    var rightMargin: CGFloat = 0 {
        didSet {
            setNeedsDisplay()
        }
    }

    @IBInspectable
    var atBottom: Bool = true {
        didSet {
            setNeedsDisplay()
        }
    }

    // MARK: Draw

    override func drawRect(rect: CGRect) {
        super.drawRect(rect)

        lineColor.setStroke()

        let context = UIGraphicsGetCurrentContext()!

        CGContextSetLineWidth(context, lineWidth)

        let y: CGFloat
        let fullHeight = CGRectGetHeight(rect)

        if atBottom {
            y = fullHeight - lineWidth * 0.5
        } else {
            y = lineWidth * 0.5
        }

        CGContextMoveToPoint(context, leftMargin, y)
        CGContextAddLineToPoint(context, CGRectGetWidth(rect) - rightMargin, y)
        
        CGContextStrokePath(context)
    }
}

