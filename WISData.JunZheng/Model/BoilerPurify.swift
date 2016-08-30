//
//  BoilerPurify.swift
//  WISData.JunZheng
//
//  Created by Allen on 16/8/24.
//  Copyright © 2016 Wisdri. All rights reserved.
//

import Alamofire
import SwiftyJSON

/// 锅炉及净化系统状态
class BoilerPurify {
    
    var Id: String?
    /// 汽包水位
    var YRGL_QBSW: String?
    /// 汽包压力
    var YRGL_QBYL: String?
    
    var YRGL_ZQLL: String?
    var YRGL_YKWD: String?
    var YRGL_CKWD: String?
    
    var JHXT_A_CO: String?
    var JHXT_A_CO2: String?
    var JHXT_A_H2: String?
    var JHXT_A_O2: String?
    
    var JHXT_B_CO: String?
    var JHXT_B_H2: String?
    var JHXT_B_O2: String?
    
    var JHXT_CKWD: String?
    var JHXT_FCHL: String?
    var JHXT_GDYL: String?
    var JHXT_HQWD: String?
    var JHXT_JKWD: String?
    var JHXT_JQWD: String?
    var JHXT_LY: String?
    
    var JQFJPL: String?
    var YQFJPL: String?
}

extension BoilerPurify {
    
    class func get(date date: String, shiftNo: String, lNo: String, completionHandler: WISValueResponse<String> -> Void) -> Void {
        
        let getURL = BaseURL + "/GetGJState?date=\(date)&shiftNo=\(shiftNo)&lNo=\(lNo)"
        Alamofire.request(.POST, getURL).responseJSON { response in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    let json = JSON(value)
//                    debugPrint(json.rawString())
                    
                    let t = WISValueResponse<String>(value: json.rawString()!, success: response.result.isSuccess)
                    completionHandler(t)
                    
                }
            case .Failure(let error):
                debugPrint(error)
            }
        }
    }
}
