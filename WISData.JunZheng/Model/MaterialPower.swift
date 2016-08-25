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
    
    // 工艺电
    var GYD: String?
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