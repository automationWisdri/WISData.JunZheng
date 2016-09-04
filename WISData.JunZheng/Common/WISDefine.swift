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
let EMPTY_STRING = ""
let SEPARATOR_HEIGHT = 1.0 / UIScreen.mainScreen().scale

var SearchParameter: Dictionary = ["date": "", "shiftNo": "2", "lNo": "2"]

///---------
/// App Info
///---------
let APP_NAME = NSBundle.mainBundle().infoDictionary!["CFBundleName"]
let APP_VERSION = NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"]
let APP_BUILD = NSBundle.mainBundle().infoDictionary!["CFBundleVersion"]

let APP_NAME_ENU = "WISData"
let APP_NAME_CHN = ""


class WISCommon {
    static let currentAppDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
}

