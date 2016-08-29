//
//  PropertyNames.swift
//  WISData.JunZheng
//
//  Created by Allen on 16/8/28.
//  Copyright © 2016 Wisdri. All rights reserved.
//

import Foundation

protocol PropertyNames {
    func propertyNames() -> [String]
}

extension PropertyNames {
    func propertyNames() -> [String] {
        return Mirror(reflecting: self).children.flatMap { $0.label }
    }
}