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
    
    class func login(username username: String, password: String, completionHandler: WISValueResponse<String> -> Void) -> Request {
        
        let loginURL = BaseURL + "/LogIn?userName=\(username)&passWord=\(password)"
        return Alamofire.request(.POST, loginURL).responseJSON { response in
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
                    if #available(iOS 9.0, *) {
                        debugPrint("JSON: \(json)")
                    }
                    if json.stringValue == "1" {
                        completionHandler(WISValueResponse(value: username, success: true))
                    } else {
                        completionHandler(WISValueResponse(success: false, message: "登录失败"))
                    }
                }
            case .Failure(let error):
                debugPrint(error)
                completionHandler(WISValueResponse(success: false, message: "登录失败"))
            }
        }
    }
}

extension User {
    private static let userNameKey = "username"
    
    class func obtainRecentUserName() -> String? {
        guard let userName = NSUserDefaults.standardUserDefaults().objectForKey(userNameKey) as? String else {
            return nil
        }
        return userName != "" ? userName : nil
    }
    
    class func storeRecentUserName(userName: String) -> () {
        NSUserDefaults.standardUserDefaults().setObject(userName, forKey: userNameKey)
    }
}
