//
//  MaterialPowerViewController.swift
//  WISData.JunZheng
//
//  Created by Allen on 16/8/24.
//  Copyright © 2016 Wisdri. All rights reserved.
//

import UIKit
import SwiftyJSON

class MaterialPowerViewController: UIViewController {
    
    // @IBOutlet weak var dataTextView: UITextView!
    @IBOutlet weak var dataView: UIScrollView!
    
    class func instantiateFromStoryboard() -> MaterialPowerViewController {
        let storyboard = UIStoryboard(name: "MaterialPower", bundle: nil)
        return storyboard.instantiateViewControllerWithIdentifier(String(self)) as! MaterialPowerViewController
    }

    private var dailyMaterialPowerView: DailyMaterialPowerView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.dailyMaterialPowerView == nil {
            self.dailyMaterialPowerView = (NSBundle.mainBundle().loadNibNamed("DailyMaterialPowerView", owner: self, options: nil).last as! DailyMaterialPowerView
            )
        }
        
        self.dataView.addSubview(dailyMaterialPowerView!)
        
        dataView.mj_header = WISRefreshHeader {[weak self] () -> () in
            self?.headerRefresh()
        }
        
//        MaterialPower.get(date: "2016/8/15", shiftNo: "1", lNo: "1") { (response: WISValueResponse<String>) in
//            if response.success {
////                SVProgressHUD.showSuccessWithStatus("登录成功")
//                
//                self.dataTextView.text = response.value
//            } else {
//                wisError(response.message)
//            }
//        }
        
        
//        Operation.get(date: "2016/8/31", shiftNo: "1", lNo: "2") { (response: WISValueResponse<String>) in
//            if response.success {
//                self.dataTextView.text = response.value
//            } else {
//                wisError(response.message)
//            }
//        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
//        self.dailyMaterialPowerView!.frame = CGRectMake(0.0, 0.0, self.dataView.bounds.size.width/*CURRENT_SCREEN_WIDTH*/, 185)
//        // CURRENT_SCREEN_WIDTH return incorrect value. Why?
//        print("dailyMaterialPowerView width: \(self.dailyMaterialPowerView?.frame.size.width)")
//        print("current screen width: \(CURRENT_SCREEN_WIDTH)")
//        print("dataView width: \(self.dataView.bounds.size.width)")
        
        arrangeMaterialPowerView(self).layoutIfNeeded()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func headerRefresh() {
        //if WISDataManager.sharedInstance().networkReachabilityStatus != .NotReachable {
        // 如果有上拉“加载更多”正在执行，则取消它
        if dataView.mj_footer != nil {
            if dataView.mj_footer.isRefreshing() {
                dataView.mj_footer.endRefreshing()
            }
        }
        
        dailyMaterialPowerView!.getData()
        
        //} else {
        //    SVProgressHUD.setDefaultMaskType(.None)
        //    SVProgressHUD.showErrorWithStatus(NSLocalizedString("Networking Not Reachable"))
        //}
        
        dataView.mj_header.endRefreshing()
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func willAnimateRotationToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        arrangeMaterialPowerView(self).layoutIfNeeded()
    }
    
    private func arrangeMaterialPowerView(materialPowerViewController: MaterialPowerViewController) -> UIView {
        let navigationBarHeight = self.navigationController?.navigationBar.bounds.height ?? CGFloat(40.0)
        let statusBarHeight = STATUS_BAR_HEIGHT
        let menuHeaderHeight = CGFloat(35.0)
        
        let dataViewWidth = CURRENT_SCREEN_WIDTH
        let dataViewHeight = CURRENT_SCREEN_HEIGHT - navigationBarHeight - statusBarHeight - menuHeaderHeight
        
        materialPowerViewController.dataView.frame = CGRectMake(0, 0, dataViewWidth, dataViewHeight)
        materialPowerViewController.dailyMaterialPowerView!.frame = CGRectMake(0.0, 0.0, self.dataView.bounds.size.width/*CURRENT_SCREEN_WIDTH*/, 185)
        return materialPowerViewController.view
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
