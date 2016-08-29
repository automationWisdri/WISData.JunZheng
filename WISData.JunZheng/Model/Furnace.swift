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
    
    /// 发气量
    var FQL: String?
    var Id: String?
    var CLSJ: String?
    var CLSL: String?

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