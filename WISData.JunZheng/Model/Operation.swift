//
//  Operation.swift
//  WISData.JunZheng
//
//  Created by Allen on 16/9/1.
//  Copyright © 2016 Wisdri. All rights reserved.
//

import Alamofire
import SwiftyJSON
import MJExtension

/// 电极操作记录

class Operation: NSObject, PropertyNames {
    
    var FLYL: String?
    var JHL: String?
    var No: String?
    var PB: String?
    var SwitchTimes: SwitchTime?
    var YFCS: String?
    var YFL: String?
}

class SwitchTime: NSObject, PropertyNames {
    var HZGD: String?
    var Hour: String?
    var Minute: String?
}

extension Operation {
    
    class func get(date date: String, shiftNo: String, lNo: String, completionHandler: WISValueResponse<JSON> -> Void) -> Void {
        
        let getURL = BaseURL + "/GetDJOperation?date=\(date)&shiftNo=\(shiftNo)&lNo=\(lNo)"
        Alamofire.request(.POST, getURL).responseJSON { response in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    let json = JSON(value)
                    
                    let t = WISValueResponse<JSON>(value: json, success: response.result.isSuccess)
                    completionHandler(t)
                    
                }
            case .Failure(let error):
                debugPrint(error)
            }
        }
    }
}