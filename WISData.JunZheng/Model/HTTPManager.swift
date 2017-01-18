//
//  HTTPManager.swift
//  WISData.JunZheng
//
//  Created by Jingwei Wu on 16/01/2017.
//  Copyright © 2017 Wisdri. All rights reserved.
//

import Foundation
import Alamofire

class HTTPManager {
    static let sharedInstance: Manager = {
        let configuration: NSURLSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.HTTPAdditionalHeaders = Manager.defaultHTTPHeaders
        configuration.timeoutIntervalForResource = 15
        
        return Manager(configuration: configuration)
    }()
}
