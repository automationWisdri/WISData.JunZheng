//
//  Furnace.swift
//  WISData.JunZheng
//
//  Created by Allen on 16/8/24.
//  Copyright © 2016 Wisdri. All rights reserved.
//

import Alamofire
import SwiftyJSON
import MJExtension

/// 电石炉系统状态

class Furnace: NSObject, PropertyNames {
    
    /// JSON List Order Id
    var Id: String?
    /// 发气量
    var FQL: String?
    /// 出炉时间
    var CLSJ: String?
    /// 出炉数量
    var CLSL: String?
    
    var BYQDWBa: String?
    var BYQDWBb: String?
    var BYQDWBc: String?
    
    var BYQWDAX: String?
    var BYQWDBX: String?
    var BYQWDCX: String?
    
    var CJDYVa: String?
    var CJDYVb: String?
    var CJDYVc: String?
    
    var CZDLIa: String?
    var CZDLIb: String?
    var CZDLIc: String?
    
    var CZDZRa: String?
    var CZDZRb: String?
    var CZDZRc: String?
    
    var DJDYVa: String?
    var DJDYVb: String?
    var DJDYVc: String?
    
    var DJWZ1: String?
    var DJWZ2: String?
    var DJWZ3: String?
    
    var DL: String?
    var GLYS: String?
    
    var LDWD1: String?
    var LDWD2: String?
    var LDWD3: String?
    var LDWD4: String?
    var LDWD5: String?
    var LDWD6: String?
    var LDWD7: String?
    
    var LQWD: String?
    
    var YCDLIa: String?
    var YCDLIb: String?
    var YCDLIc: String?
    
    var YCDYVa: String?
    var YCDYVb: String?
    var YCDYVc: String?
    
    var LYH: String?
    var WGGL: String?
    var XHSCSWD: String?
    var XHSJSWD: String?
    var YGGL: String?

}

extension Furnace {
    
    class func get(date date: String, shiftNo: String, lNo: String, completionHandler: WISValueResponse<[JSON]> -> Void) -> Void {
        
        let getURL = BaseURL + "/GetDSLState?date=\(date)&shiftNo=\(shiftNo)&lNo=\(lNo)"
        Alamofire.request(.POST, getURL).responseJSON { response in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    let json = JSON(value)
                    
                    if let furnaceArray = Furnace.mj_objectArrayWithKeyValuesArray(json["Infos"].rawString()) {
                        for furnace in furnaceArray {
//                            debugPrint(furnace.Id)
                        }
                    }
                    let t = WISValueResponse<[JSON]>(value: json["Infos"].arrayValue, success: response.result.isSuccess)
                    completionHandler(t)
                }
            case .Failure(let error):
                debugPrint(error)
            }
        }
    }
}