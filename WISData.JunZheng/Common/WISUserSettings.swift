//
//  WISUserSettings.swift
//  WISData.JunZheng
//
//  Created by Allen on 16/8/24.
//  Copyright © 2016 Wisdri. All rights reserved.
//

import UIKit

let keyPrefix =  "com.wisdriis.settings."

class WISUserSettings: NSObject {
    
    static let sharedInstance = WISUserSettings()
    
    private override init() {
        super.init()
    }
    
    subscript(key:String) -> String? {
        
        get {
            return NSUserDefaults.standardUserDefaults().objectForKey(keyPrefix + key) as? String
        }
        set {
            NSUserDefaults.standardUserDefaults().setValue(newValue, forKey: keyPrefix + key )
        }
    }
}
