//
//  WISClient.swift
//  WISData.JunZheng
//
//  Created by Allen on 16/8/15.
//  Copyright © 2016 Wisdri. All rights reserved.
//

import UIKit
import DrawerController

class WISClient: NSObject {
    
    static let sharedInstance = WISClient()
    
    var drawerController: DrawerController? = nil
    var centerViewController: DataHomeViewController? = nil
    var centerNavigation: UINavigationController? = nil
    
    // 当前程序中，最上层的 NavigationController
    var topNavigationController : UINavigationController {
        get{
            return WISClient.getTopNavigationController(WISClient.sharedInstance.centerNavigation!)
        }
    }
    
    private class func getTopNavigationController(currentNavigationController: UINavigationController) -> UINavigationController {
        
        if let topNav = currentNavigationController.visibleViewController?.navigationController {
            if topNav != currentNavigationController && topNav.isKindOfClass(UINavigationController.self) {
                return getTopNavigationController(topNav)
            }
        }
        return currentNavigationController
    }
}
