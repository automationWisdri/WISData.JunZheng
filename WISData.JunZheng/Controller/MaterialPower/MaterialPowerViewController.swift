//
//  MaterialPowerViewController.swift
//  WISData.JunZheng
//
//  Created by Allen on 16/8/24.
//  Copyright © 2016 Wisdri. All rights reserved.
//

import UIKit
import SwiftyJSON
import SVProgressHUD

class MaterialPowerViewController: UIViewController {
    
    // @IBOutlet weak var dataTextView: UITextView!
    @IBOutlet weak var dataView: UIScrollView!
    
    private var noDataView: NoDataView!
    private var hasRefreshedData: Bool!
    
    class func instantiateFromStoryboard() -> MaterialPowerViewController {
        let storyboard = UIStoryboard(name: "MaterialPower", bundle: nil)
        return storyboard.instantiateViewControllerWithIdentifier(String(self)) as! MaterialPowerViewController
    }

    private var dailyMaterialPowerView: DailyMaterialPowerView?
    private var materialPowerView: MaterialPowerView?
    private var operationView: OperationView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Observing notifications
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.handleNotification(_:)), name: DataSearchNotification, object: nil)
        // initialize No data View
        if self.noDataView == nil {
            self.noDataView = (NSBundle.mainBundle().loadNibNamed("NoDataView", owner: self, options: nil)!.last as! NoDataView
            )
        }
        
        dataView.mj_header = WISRefreshHeader {[weak self] () -> () in
            self?.headerRefresh()
        }
        
        self.hasRefreshedData = false
        
        //
        // Daily Material Power View Section
        //
        if self.dailyMaterialPowerView == nil {
            self.dailyMaterialPowerView = (NSBundle.mainBundle().loadNibNamed("DailyMaterialPowerView", owner: self, options: nil)!.last as! DailyMaterialPowerView
            )
        }
        //
        // Material Power View Section
        //
        if self.materialPowerView == nil {
            self.materialPowerView = (NSBundle.mainBundle().loadNibNamed("MaterialPowerView", owner: self, options: nil)!.last as! MaterialPowerView
            )
        }
        //
        // Operation View Section
        //
        if self.operationView == nil {
            self.operationView = (NSBundle.mainBundle().loadNibNamed("OperationView", owner: self, options: nil)!.last as! OperationView
            )
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        arrangeMaterialPowerView(self).layoutIfNeeded()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        // Get data for data table
        if !hasRefreshedData { getData() }
    }
    
    func handleNotification(notification: NSNotification) -> Void {
        getData()
    }
    
    func getDailyMaterialPowerData(completionHandler: (Bool, String) -> Void) {
        
        DailyMaterialPower.get(date: SearchParameter["date"]!, lNo: SearchParameter["lNo"]!) { (response: WISValueResponse<JSON>) in
 
            if response.success {
                self.dailyMaterialPowerView!.dailyMaterialPowerContentJSON = response.value!
                self.dailyMaterialPowerView?.viewHeight = DailyMaterialPowerView.defaultViewHeight
                self.dailyMaterialPowerView!.initialDrawTable()
                self.dataView.addSubview(self.dailyMaterialPowerView!)
            } else {
                self.dailyMaterialPowerView?.removeFromSuperview()
                self.dailyMaterialPowerView?.viewHeight = CGFloat(0)
            }
            completionHandler(response.success, response.message)
        }
    }
    
    func getMaterialPowerData(completionHandler: (Bool, String) -> Void) {
        
        MaterialPower.get(date: SearchParameter["date"]!, shiftNo: SearchParameter["shiftNo"]!, lNo: SearchParameter["lNo"]!) { (response: WISValueResponse<JSON>) in
            
            if response.success {
                // debugPrint(response.value)
                let tableContentJSON = response.value!["MaterialPower"]
                self.materialPowerView!.tableContentJSON = tableContentJSON
                
                let switchContentJSON = tableContentJSON["SwithTimeReasons"].arrayValue
                self.materialPowerView!.switchContentJSON = switchContentJSON
                
                var switchRowCount = 0
                if switchContentJSON.count > 1 {
                    switchRowCount = switchContentJSON.count
                } else {
                    switchRowCount = 1
                }
                let viewHeight = CGFloat(switchRowCount) * DataTableBaseRowHeight + 60 + 35
                self.materialPowerView!.viewHeight = viewHeight
                
                self.materialPowerView!.initialDrawTable(switchRowCount, viewHeight: viewHeight)
                self.dataView.addSubview(self.materialPowerView!)
                
            } else {
                self.materialPowerView?.removeFromSuperview()
                self.materialPowerView?.viewHeight = CGFloat(0.0)
            }
            completionHandler(response.success, response.message)
        }
    }
    
    func getOperationData(completionHandler: (Bool, String) -> Void) {
        
        Operation.get(date: SearchParameter["date"]!, shiftNo: SearchParameter["shiftNo"]!, lNo: SearchParameter["lNo"]!) { (response: WISValueResponse<JSON>) in
            if response.success {
                debugPrint(response.value!)
                let tableContentJSON = response.value!["Infos"].arrayValue
                print(tableContentJSON)
                self.operationView!.tableContentJSON = tableContentJSON
                
                var switchRowCount = [Int]()
                self.operationView?.switchContentJSON.removeAll()
                for i in 0 ..< tableContentJSON.count {
                    let switchContentJSON = tableContentJSON[i]["SwitchTimes"].arrayValue
                    self.operationView!.switchContentJSON.append(switchContentJSON)
                    
                    if switchContentJSON.count > 1 {
                        switchRowCount.append(switchContentJSON.count)
                    } else {
                        switchRowCount.append(1)
                    }
                }
                
                let totalRowCount = switchRowCount.reduce(0, combine: + )
                
                let viewHeight = CGFloat(totalRowCount) * DataTableBaseRowHeight + 60 + 35
                self.operationView!.viewHeight = viewHeight
                self.operationView!.initialDrawTable(switchRowCount, viewHeight: viewHeight)
                self.dataView.addSubview(self.operationView!)
            } else {
                self.operationView?.removeFromSuperview()
                self.operationView?.viewHeight = CGFloat(0.0)
            }
            completionHandler(response.success, response.message)
        }
    }
    
    func getData() {
        SVProgressHUD.showWithStatus("数据获取中...")
        
        let groupQueue = dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        let questGroup = dispatch_group_create()
        
        enum RequestTableType {
            case DailyMaterialPower(Bool)
            case MaterialPower(Bool)
            case Operation(Bool)
        }
        
        struct questResult {
            let success: Bool
            let message: String
            let requestType: RequestTableType
        }
        
        var result: [questResult] = []
        
        weak var weakSelf = self
        
        dispatch_group_enter(questGroup)
        dispatch_async(groupQueue) {
            weakSelf!.getDailyMaterialPowerData() { success, message in
                result.append(questResult(success:success, message: message, requestType: .DailyMaterialPower(success)))
                dispatch_group_leave(questGroup)
            }
        }
        
        dispatch_group_enter(questGroup)
        dispatch_async(groupQueue) {
            weakSelf!.getMaterialPowerData() { success, message in
                result.append(questResult(success:success, message: message, requestType: .MaterialPower(success)))
                dispatch_group_leave(questGroup)
            }
        }
        
        dispatch_group_enter(questGroup)
        dispatch_async(groupQueue) {
            weakSelf!.getOperationData() { success, message in
                result.append(questResult(success:success, message: message, requestType: .Operation(success)))
                dispatch_group_leave(questGroup)
            }
        }
        
        dispatch_group_notify(questGroup, dispatch_get_main_queue()) {
            let failedResult = result.filter { !$0.success }
            if failedResult.count >= 3 {
                self.noDataView.frame = self.dataView.frame
                self.dataView.addSubview(self.noDataView)
                wisError(result[0].message)
                self.hasRefreshedData = false
            } else {
                self.noDataView.removeFromSuperview()
                
                if failedResult.count <= 0{
                    SVProgressHUD.setDefaultMaskType(.None)
                    SVProgressHUD.showSuccessWithStatus("数据获取成功！")
                    self.hasRefreshedData = true
                } else {
                    var hintString = ""
                    for res in result {
                        switch res.requestType {
                        case .DailyMaterialPower(let success):
                                hintString += success ? "" : "全天消耗数据获取失败\n"
                        case .MaterialPower(let success):
                            hintString += success ? "" : "原料消耗数据获取失败\n"
                        case .Operation(let success):
                            hintString += success ? "" : "电极操作数据获取失败\n"
                        }
                    }
                    SVProgressHUD.setDefaultMaskType(.None)
                    SVProgressHUD.showInfoWithStatus(hintString + "请再次刷新")

                    self.hasRefreshedData = false
                }
            }
            self.arrangeMaterialPowerView(self).layoutIfNeeded()
        }
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
        getData()
        
        //} else {
        //    SVProgressHUD.setDefaultMaskType(.None)
        //    SVProgressHUD.showErrorWithStatus(NSLocalizedString("Networking Not Reachable"))
        //}
        
        dataView.mj_header.endRefreshing()
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if currentDevice.isPad {
            return .All
        } else {
            return .AllButUpsideDown
        }
    }
    
    override func preferredInterfaceOrientationForPresentation() -> UIInterfaceOrientation {
        return .Portrait
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        coordinator.animateAlongsideTransition({ [unowned self] _ in
            self.arrangeMaterialPowerView(self)
        }, completion:nil)
    }
    
    private func arrangeMaterialPowerView(materialPowerViewController: MaterialPowerViewController) -> UIView {
        
        if materialPowerViewController.view.subviews.contains(materialPowerViewController.noDataView) {
            materialPowerViewController.noDataView.frame = materialPowerViewController.dataView.frame
        } else {
            let navigationBarHeight = self.navigationController?.navigationBar.bounds.height ?? CGFloat(40.0)
            let statusBarHeight = STATUS_BAR_HEIGHT
            let menuHeaderHeight = CGFloat(35.0)
            
            let dataViewWidth = CURRENT_SCREEN_WIDTH
            let dataViewHeight = CURRENT_SCREEN_HEIGHT - navigationBarHeight - statusBarHeight - menuHeaderHeight
            
            materialPowerViewController.dataView.frame = CGRectMake(0, 0, dataViewWidth, dataViewHeight)
            //
            // arrange daily material power view
            materialPowerViewController.dailyMaterialPowerView!.frame = CGRectMake(0.0, 0.0, /*self.dataView.bounds.size.width*/ dataViewWidth, self.dailyMaterialPowerView!.viewHeight)
            materialPowerViewController.dailyMaterialPowerView?.arrangeDailyMaterialPowerSubView(self.materialPowerView!.viewHeight)
            //
            // arrange material power view
            materialPowerViewController.materialPowerView!.frame = CGRectMake(0.0, self.dailyMaterialPowerView!.viewHeight, /*self.dataView.bounds.size.width*/ dataViewWidth, self.materialPowerView!.viewHeight)
            materialPowerViewController.materialPowerView?.arrangeMaterialPowerSubView(self.materialPowerView!.viewHeight)
            
            materialPowerViewController.operationView!.frame = CGRectMake(0.0, self.dailyMaterialPowerView!.viewHeight + self.materialPowerView!.viewHeight, /*self.dataView.bounds.size.width*/ dataViewWidth, self.operationView!.viewHeight)
            materialPowerViewController.operationView!.arrangeOperationSubView(self.operationView!.viewHeight)
            
            
            materialPowerViewController.dataView.contentSize = CGSizeMake(dataViewWidth, (self.dailyMaterialPowerView!.viewHeight + self.materialPowerView!.viewHeight + self.operationView!.viewHeight + WISCommon.additionalHeightInView))
        }
        return materialPowerViewController.view
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: DataSearchNotification, object: nil)
    }

}
