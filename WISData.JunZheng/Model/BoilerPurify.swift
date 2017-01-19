//
//  BoilerPurify.swift
//  WISData.JunZheng
//
//  Created by Allen on 16/8/24.
//  Copyright © 2016 Wisdri. All rights reserved.
//

import Alamofire
import SwiftyJSON
import MJExtension

/// 锅炉及净化系统状态
class BoilerPurify: NSObject, PropertyNames {
    
    var Id: String?
    var YRGL_JKWD: String?
    var YRGL_CKWD: String?
    /// 汽包水位
    var YRGL_QBSW: String?
    /// 汽包压力
    var YRGL_QBYL: String?
    var YRGL_ZQLL: String?
    
    var JHXT_JKWD: String?
    var JHXT_CKWD: String?
    
    var JHXT_A_H2: String?
    var JHXT_A_O2: String?
    var JHXT_A_CO: String?
    var JHXT_A_CO2: String?
    
    var JHXT_B_H2: String?
    var JHXT_B_O2: String?
    var JHXT_B_CO: String?
    
    var JHXT_HQWD: String?
    var JHXT_JQWD: String?
    var JHXT_FCHL: String?
    var JHXT_GDYL: String?
    var JHXT_LY: String?
    var YQFJPL: String?
    var JQFJPL: String?
}

extension BoilerPurify {
    
    class func get(date date: String, shiftNo: String, lNo: String, completionHandler: WISValueResponse<[JSON]> -> Void) -> Void {
        
        let getURL = BaseURL + "/GetGJState?date=\(date)&shiftNo=\(shiftNo)&lNo=\(lNo)"
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
                    
                    if let _ = BoilerPurify.mj_objectArrayWithKeyValuesArray(json["Infos"].rawString()) {
                        // do something
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
