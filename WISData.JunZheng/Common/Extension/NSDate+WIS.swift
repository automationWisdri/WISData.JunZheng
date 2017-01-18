//
//  NSDate+WIS.swift
//  WISData.JunZheng
//
//  Created by Jingwei Wu on 17/01/2017.
//  Copyright © 2017 Wisdri. All rights reserved.
//

import Foundation

extension NSDate {
    class var today: NSDate {
        get { return NSDate.init() }
    }
    
    class var yesterday: NSDate {
        get { return NSDate.init(timeIntervalSinceNow: -24*60*60.0) }
    }
    
    class var tomorrow: NSDate {
        get { return NSDate.init(timeIntervalSinceNow: +24*60*60.0) }
    }
    
    var noon: NSDate {
        get {
            let calendar = NSCalendar.currentCalendar()
            let todayDateComponents: NSDateComponents = NSDateComponents.init()
            todayDateComponents.hour = 12
            todayDateComponents.minute = 0
            todayDateComponents.second = 0
            return calendar.dateByAddingComponents(todayDateComponents, toDate: self, options: .MatchStrictly)!
        }
    }
    
    var isNowAfternoonOrLater: Bool {
        get {
            let result = self.compare(self.noon)
            return result == NSComparisonResult.OrderedDescending ? true : false
        }
    }
}

