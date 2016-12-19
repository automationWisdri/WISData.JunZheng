//
//  WISDefine.swift
//  WISData.JunZheng
//
//  Created by Allen on 16/8/22.
//  Copyright © 2016 Wisdri. All rights reserved.
//

import UIKit
import DeviceKit

///---------
/// Common
///---------
let BaseURL = "http://service.wisdriis.com:9090/MyService.svc"
let currentDevice = Device()

var CURRENT_SCREEN_WIDTH: CGFloat {
    // I really don't not the reason, but on simulators, the code below works exactly right~ 2016.09.03
//    if currentDevice.isPad/*device.isOneOf([.Simulator(.iPad2), .iPadAir, .iPadAir2, .iPadPro])*/ {
//        return UIScreen.mainScreen().bounds.size.height
//    } else {
        return UIScreen.mainScreen().bounds.size.width
    //}
}

var CURRENT_SCREEN_HEIGHT: CGFloat {
//    if currentDevice.isPad/*device.isOneOf([.Simulator(.iPad2), .iPadAir, .iPadAir2, .iPadPro])*/ {
//        return UIScreen.mainScreen().bounds.size.width
//    } else {
        return UIScreen.mainScreen().bounds.size.height
    //}
}

var STATUS_BAR_HEIGHT: CGFloat {
    let orientation = UIApplication.sharedApplication().statusBarOrientation
    if  orientation == .Portrait || orientation == .PortraitUpsideDown {
        return UIApplication.sharedApplication().statusBarFrame.height
    } else {
        return Device().isPad ? UIApplication.sharedApplication().statusBarFrame.height : CGFloat(0.0)
    }
}

var NAVIGATION_BAR_HEIGHT: CGFloat = 40.0

let EMPTY_STRING = ""
let SEPARATOR_HEIGHT = 1.0 / UIScreen.mainScreen().scale

var SearchParameter: Dictionary = ["date": "", "shiftNo": "2", "lNo": ""]
let DJName = ["1# 电极", "2# 电极", "3# 电极"]

let DataSearchNotification = "DataSearchNotification"

enum ShiftType: Int {
    
    case MorningShift = 0
    case MiddleShift = 1
    case NightShift = 2
    
    static let count: Int = {
        return 3
    }()
    
    var stringOfType: String {
        switch self {
        case .MorningShift:
            return "早班"
        case .MiddleShift:
            return "中班"
        case .NightShift:
            return "晚班"
        }
    }
    
    var getShiftNoForSearch: String {
        switch self {
        case .MorningShift:
            return "2"
        case .MiddleShift:
            return "3"
        case .NightShift:
            return "1"
        }
    }
}

///---------
/// App Info
///---------
let APP_NAME = NSBundle.mainBundle().infoDictionary!["CFBundleName"]
let APP_VERSION = NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"]
let APP_BUILD = NSBundle.mainBundle().infoDictionary!["CFBundleVersion"]

let APP_NAME_ENU = "WISData"
let APP_NAME_CHN = "生产数据"


class WISCommon {
    static let currentAppDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    static let additionalHeightInView: CGFloat = CGFloat(30.0)
    
    static let DataTableColumnWidth: CGFloat = CGFloat(80.0)
    static let firstColumnViewWidth: CGFloat = CGFloat(95.0)
    static let pageMenuHeaderHeight: CGFloat = CGFloat(35.0)
    static let viewHeaderTitleHeight: CGFloat = CGFloat(35.0)
}

