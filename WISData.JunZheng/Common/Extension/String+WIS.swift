//
//  String+WIS.swift
//  WISData.JunZheng
//
//  Created by Allen on 16/8/23.
//  Copyright © 2016 Wisdri. All rights reserved.
//

import Foundation

extension String {
    
    public var length: Int {
        get {
            return self.characters.count
        }
    }
    
    /// SwiftyJSON在将网络请求获得的float数据转换为NSNumber数据类型的过程中，由于精度造成了偏差，会出现原数据小数点后只有1、2位，
    /// 可转换后的String小数点凭空出现若干位的情况.
    /// 本函数用于将多出的部分按照需要做截断，放弃掉多出的部分.
    /// 本函数对于整数或小数点后位数不超过设定值的String不产生影响.
    public func trimNumberFromFractionalPart(by: Int = 2) -> String {
        guard let indexOfDot = self.characters.indexOf(".") else {
            return self
        }
        
        let decimalPart = self.substringToIndex(indexOfDot)
        let fractionalPart = self.substringFromIndex(indexOfDot)
        
        guard fractionalPart.characters.count > by else {
            return self
        }
        
        let idx = fractionalPart.startIndex.advancedBy(by + 1)
        let trimmedFractionalPart = fractionalPart.substringToIndex(idx)
        
        return decimalPart + trimmedFractionalPart
    }
}