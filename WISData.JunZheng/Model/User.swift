//
//  User.swift
//  WISData.JunZheng
//
//  Created by Allen on 16/8/22.
//  Copyright © 2016 Wisdri. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class User {
    
    var username: String?
    
}

extension User {
    
    class func login(username username: String, password: String, completionHandler: WISValueResponse<String> -> Void) {
        
        let loginURL = BaseURL + "/LogIn?userName=\(username)&passWord=\(password)"
        Alamofire.request(.POST, loginURL).responseJSON { response in
            /*
             * For test
            
            print("request is \(response.request)")  // original URL request
            print("response is \(response.response)") // URL response
            print("data is \(response.data)")     // server data
            print("result is \(response.result)")   // result of response serialization
            */
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    let json = JSON(value)
                    debugPrint("JSON: \(json)")
                    if json.stringValue == "1" {
                        completionHandler(WISValueResponse(value: username, success: true))
                    }
                }
            case .Failure(let error):
                debugPrint(error)
                completionHandler(WISValueResponse(success: false, message: "登录失败"))
            }
        }
    }
    
}
