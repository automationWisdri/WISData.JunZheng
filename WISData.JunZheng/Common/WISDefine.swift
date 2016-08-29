//
//  WISDefine.swift
//  WISData.JunZheng
//
//  Created by Allen on 16/8/22.
//  Copyright © 2016 Wisdri. All rights reserved.
//

import UIKit

///---------
/// Common
///---------
let BaseURL = "http://service.wisdriis.com:9090/MyService.svc"

let SCREEN_WIDTH = UIScreen.mainScreen().bounds.size.width
let SCREEN_HEIGHT = UIScreen.mainScreen().bounds.size.height
let EMPTY_STRING = ""
let SEPARATOR_HEIGHT = 1.0 / UIScreen.mainScreen().scale

var SearchParameter: Dictionary = ["date": "", "shiftNo": "1", "lNo": "1"]

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

