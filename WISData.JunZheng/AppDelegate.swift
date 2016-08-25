//
//  AppDelegate.swift
//  WISData.JunZheng
//
//  Created by Jingwei Wu on 8/15/16.
//  Copyright © 2016 Wisdri. All rights reserved.
//

import UIKit
import DrawerController
import SVProgressHUD

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        // Override point for customization after application launch.
        self.window!.backgroundColor = UIColor.whiteColor()
        self.window!.makeKeyAndVisible()

        SVProgressHUD.setForegroundColor(UIColor(white: 1, alpha: 1))
        SVProgressHUD.setBackgroundColor(UIColor(white: 0.15, alpha: 0.85))
        SVProgressHUD.setDefaultStyle(.Custom)
        SVProgressHUD.setMinimumDismissTimeInterval(1.5)
        SVProgressHUD.setDefaultMaskType(.Clear)
        SVProgressHUD.setDefaultAnimationType(.Native)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(didDisappearProgressHUD), name: SVProgressHUDDidDisappearNotification, object: nil)
        
        self.window?.rootViewController = LoginViewController()
        
        return true
    }
    
    // Mark: Function
    
    func didDisappearProgressHUD() {
        SVProgressHUD.setDefaultMaskType(.Clear)
    }
    
    func startMainStory() {

        let centerNav = WISNavigationController(rootViewController: DataHomeViewController())
        let leftViewController = LeftMenuViewController()
        let drawerController = DrawerController(centerViewController: centerNav, leftDrawerViewController: leftViewController)
        
        drawerController.maximumLeftDrawerWidth = 150
        drawerController.openDrawerGestureModeMask = OpenDrawerGestureMode.PanningCenterView
        drawerController.closeDrawerGestureModeMask = CloseDrawerGestureMode.All
        drawerController.animationVelocity = 420.0
        
        self.window?.rootViewController = drawerController
        
        WISClient.sharedInstance.drawerController = drawerController
        WISClient.sharedInstance.centerViewController = centerNav.viewControllers[0] as? DataHomeViewController
        WISClient.sharedInstance.centerNavigation = centerNav

    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

