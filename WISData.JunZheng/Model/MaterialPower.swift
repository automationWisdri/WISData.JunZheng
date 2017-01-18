//
//  MaterialPower.swift
//  WISData.JunZheng
//
//  Created by Allen on 16/8/22.
//  Copyright © 2016 Wisdri. All rights reserved.
//

import Alamofire
import SwiftyJSON
import MJExtension

class MaterialPower: NSObject, PropertyNames {
    
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
    var SwithTimeReasons: SwitchTimeReason?
}

class SwitchTimeReason: NSObject, PropertyNames {
    
    var CutHour: String?
    var CutMinute: String?
    var OnHour: String?
    var OnMinute: String?
    var Reason: String?
}

class DailyMaterialPower: NSObject, PropertyNames {
    
    var GYD: String?
    var BQCL: String?
    var JHHZL: String?
    var LTZH: String?
    var WYMZH: String?
    var PJPB: String?
    var JTZH: String?
    var SHZH: String?
    var YQPS: String?
    var YQZL: String?
}

extension MaterialPower {
    class func get(date date: String, shiftNo: String, lNo: String, completionHandler: WISValueResponse<JSON> -> Void) -> Void {
        
        let getURL = BaseURL + "/GetMaterialPower?date=\(date)&shiftNo=\(shiftNo)&lNo=\(lNo)"
        HTTPManager.sharedInstance.request(.POST, getURL).responseJSON { response in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    let json = JSON(value)
//                    debugPrint("JSON: \(json)")
//                    debugPrint(json.rawString())
                    
                    guard json["Result"] == 1 else {
                        let t = WISValueResponse<JSON>(value: JSON.null, success: false)
                        t.message = "未检索到所需数据, \n请修改查询条件后重试。"
                        completionHandler(t)
                        return
                    }
                    
                    // switchCount is one by default
                    var switchCount = 1
                    if let str = SwitchTimeReason.mj_objectArrayWithKeyValuesArray(json["SwithTimeReasons"].rawString()!) {
                        switchCount = str.count
                    }
                    
                    let t = WISValueResponse<JSON>(value: json, success: true)
                    completionHandler(t)
                }
                
            case .Failure(let error):
                debugPrint(error)
                debugPrint("\nError Description: " + error.localizedDescription)
                let t = WISValueResponse<JSON>(value: JSON.null, success: false)
                t.message = error.localizedDescription + "\n请检查设备的网络配置。"
                completionHandler(t)
            }
        }
    }
}

extension DailyMaterialPower {

    class func get(date date: String, lNo: String, completionHandler: WISValueResponse<JSON> -> Void) -> Void {
        
        let getURL = BaseURL + "/GetDailyMateralPower?date=\(date)&lNo=\(lNo)"
        HTTPManager.sharedInstance.request(.POST, getURL).responseJSON { response in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    let json = JSON(value)
                    
                    guard json["Result"] == 1 else {
                        let t = WISValueResponse<JSON>(value: JSON.null, success: false)
                        t.message = "未检索到所需数据, \n请修改查询条件后重试。"
                        completionHandler(t)
                        return
                    }
                    
//                    let dailyMaterialPower = DailyMaterialPower.mj_objectWithKeyValues(json.rawString())
//                    for p in DailyMaterialPower().propertyNames() {
//                        debugPrint(p)
//                    }
//                    
//                    debugPrint(dailyMaterialPower.PJPB)
                    
                    let t = WISValueResponse<JSON>(value: json, success: true)
                    completionHandler(t)
                }
                
            case .Failure(let error):
                debugPrint(error)
                debugPrint("\nError Description: " + error.localizedDescription)
                let t = WISValueResponse<JSON>(value: JSON.null, success: false)
                t.message = error.localizedDescription + "\n请检查设备的网络设置。"
                completionHandler(t)
            }
        }
    }
}
