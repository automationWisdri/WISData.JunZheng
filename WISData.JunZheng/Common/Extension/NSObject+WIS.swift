//
//  NSObject+WIS.swift
//  WISData.JunZheng
//
//  Created by Allen on 16/8/23.
//  Copyright © 2016 Wisdri. All rights reserved.
//

import Foundation

extension NSObject {
    /**
     当前的类名字符串
     
     - returns: 当前类名的字符串
     */
    public class func Identifier() -> String {
        return "\(self)";
    }
}