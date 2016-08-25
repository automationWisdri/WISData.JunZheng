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
    
    /// 汽包水位
    var YRGL_QBSW: String?
    /// 汽包压力
    var YRGL_QBYL: String?
}

extension BoilerPurify {
    
    class func get(date date: String, shiftNo: String, lNo: String, completionHandler: WISValueResponse<String> -> Void) -> Void {
        
        let getURL = BaseURL + "/GetGJState?date=\(date)&shiftNo=\(shiftNo)&lNo=\(lNo)"
        Alamofire.request(.POST, getURL).responseJSON { response in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    let json = JSON(value)
                    debugPrint(json.rawString())
                    
                    let t = WISValueResponse<String>(value: json.rawString()!, success: response.result.isSuccess)
                    completionHandler(t)
                    
                }
            case .Failure(let error):
                debugPrint(error)
            }
        }
    }
}
