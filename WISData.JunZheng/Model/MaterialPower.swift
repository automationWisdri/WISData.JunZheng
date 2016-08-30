//
//  MaterialPower.swift
//  WISData.JunZheng
//
//  Created by Allen on 16/8/22.
//  Copyright © 2016 Wisdri. All rights reserved.
//

import Alamofire
import SwiftyJSON

class MaterialPower {
    
    /// 工艺电
    var GYD: String?
    var BQCL: String?
    var JHHZL: String?
    var JTZH: String?
    var LTGDT: String?
    var LTHF: String?
    var LTHFF: String?
    var LTSF: String?
    var LTZH: String?
    var PJPB: String?
    var SHCaO: String?
    var SHGS: String?
    var SHSS: String?
    var SHZH: String?
    
    var WYMGDT: String?
    var WYMHF: String?
    var WYMHFF: String?
    var WYMSF: String?
    var WYMZH: String?
    var YQPS: String?
    var YQZL: String?
    
    var Remark: String?
    var SwithTimeReasons: String?
}

extension MaterialPower {
    
    class func get(date date: String, shiftNo: String, lNo: String, completionHandler: WISValueResponse<String> -> Void) -> Void {
        
        let getURL = BaseURL + "/GetMaterialPower?date=\(date)&shiftNo=\(shiftNo)&lNo=\(lNo)"
        Alamofire.request(.POST, getURL).responseJSON { response in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    let json = JSON(value)
//                    debugPrint("JSON: \(json)")
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