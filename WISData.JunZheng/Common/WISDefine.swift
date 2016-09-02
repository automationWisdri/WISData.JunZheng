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

var CURRENT_SCREEN_WIDTH: CGFloat {
    return UIScreen.mainScreen().bounds.size.width
}

var CURRENT_SCREEN_HEIGHT: CGFloat {
    return UIScreen.mainScreen().bounds.size.height
}

var STATUS_BAR_HEIGHT: CGFloat {
    if UIDevice.currentDevice().orientation.isPortrait {
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

