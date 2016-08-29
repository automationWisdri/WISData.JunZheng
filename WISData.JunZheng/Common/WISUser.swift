//
//  WISUser.swift
//  WISData.JunZheng
//
//  Created by Allen on 16/8/28.
//  Copyright © 2016 Wisdri. All rights reserved.
//

import UIKit
import Alamofire

let kUserName = "com.wisdriis.username"

class WISUser: NSObject {
    
    static let sharedInstance = WISUser()
    /// 用户信息
    private var _user: User?
    var user: User? {
        get {
            return self._user
        }
        set {
            //保证给user赋值是在主线程进行的
            //原因是 有很多UI可能会监听这个属性，这个属性发生更改时，那些UI也会相应的修改自己，所以要在主线程操作
            dispatch_sync_safely_main_queue {
                self._user = newValue
                self.username = newValue?.username
            }
        }
    }

    dynamic var username:String?



    private override init() {
        super.init()
//        dispatch_sync_safely_main_queue {
//            self.setup()
//            //如果客户端是登录状态，则去验证一下登录有没有过期
//            if self.isLogin {
//                self.verifyLoginStatus()
//            }
//        }
    }
    
    func setup(){
        self.username = WISUserSettings.sharedInstance[kUserName]
    }


    /// 是否登录
    var isLogin:Bool {
        get {
            if self.username?.length > 0 {
                return true
            }
            else {
                return false
            }
        }
    }

//    func ensureLoginWithHandler(handler:()->()) {
//        guard isLogin else {
//            V2Inform("请先登录")
//            return
//        }
//        handler()
//    }
    /**
     退出登录
     */
    func loginOut() {
        removeAllCookies()
        self.user = nil
        self.username = nil

        //清空settings中的username
        WISUserSettings.sharedInstance[kUserName] = nil
    }

    /**
     删除客户端所有cookies
     */
    func removeAllCookies() {
        let storage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        if let cookies = storage.cookies {
            for cookie in cookies {
                storage.deleteCookie(cookie)
            }
        }
    }
    
    /**
     验证客户端登录状态

     - returns: ture: 正常登录 ,false: 登录过期，没登录
     */
//    func verifyLoginStatus() {
//        Alamofire.request(.GET, V2EXURL + "new", parameters: nil, encoding: .URL, headers: MOBILE_CLIENT_HEADERS).responseString(encoding: nil) { (response) -> Void in
//            if response.request?.URL?.absoluteString == response.response?.URL?.absoluteString {
//                //登录正常
//            }
//            else{
//                //没有登录 ,注销客户端
//                dispatch_sync_safely_main_queue({ () -> () in
//                    self.loginOut()
//                })
//            }
//        }
//    }
}
