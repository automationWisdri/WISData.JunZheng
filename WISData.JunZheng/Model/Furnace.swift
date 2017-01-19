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
    /// 出炉时间
    var CLSJ: String?
    
    var LYH: String?
    /// 出炉数量
    var CLSL: String?
    /// 发气量
    var FQL: String?
    
    var BYQDWBa: String?
    var BYQDWBb: String?
    var BYQDWBc: String?
    
    var YCDYVa: String?
    var YCDYVb: String?
    var YCDYVc: String?
    
    var DJDYVa: String?
    var DJDYVb: String?
    var DJDYVc: String?
    
    var YCDLIa: String?
    var YCDLIb: String?
    var YCDLIc: String?
    
    var CZDLIa: String?
    var CZDLIb: String?
    var CZDLIc: String?
    
    var CZDZRa: String?
    var CZDZRb: String?
    var CZDZRc: String?
    
    var CJDYVa: String?
    var CJDYVb: String?
    var CJDYVc: String?
    
    var DL: String?
    var YGGL: String?
    var WGGL: String?
    var GLYS: String?
    
    var BYQWDAX: String?
    var BYQWDBX: String?
    var BYQWDCX: String?
    
    var DJWZ1: String?
    var DJWZ2: String?
    var DJWZ3: String?

    var LDWD1: String?
    var LDWD2: String?
    var LDWD3: String?
    var LDWD4: String?
    var LDWD5: String?
    var LDWD6: String?
    var LDWD7: String?
    
    var LQWD: String?
    
    var XHSJSWD: String?
    var XHSCSWD: String?

}

extension Furnace {
    
    class func get(date date: String, shiftNo: String, lNo: String, completionHandler: WISValueResponse<[JSON]> -> Void) -> Void {
        
        let getURL = BaseURL + "/GetDSLState?date=\(date)&shiftNo=\(shiftNo)&lNo=\(lNo)"
        
        HTTPManager.sharedInstance.request(.POST, getURL).responseJSON { response in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    let json = JSON(value)
                    
                    guard json["Result"] == 1 else {
                        let t = WISValueResponse<[JSON]>(value: [JSON.null], success: false)
                        t.message = "未检索到所需数据, \n请修改查询条件后重试。"
                        completionHandler(t)
                        return
                    }

                    let t = WISValueResponse<[JSON]>(value: json["Infos"].arrayValue, success: true)
                    completionHandler(t)
                }
                
            case .Failure(let error):
                debugPrint(error)
                debugPrint("\nError Description: " + error.localizedDescription)
                let t = WISValueResponse<[JSON]>(value: [JSON.null], success: false)
                t.message = error.localizedDescription + "\n请检查设备的网络设置, 然后下拉页面刷新。"
                completionHandler(t)
            }
        }
    }
}
