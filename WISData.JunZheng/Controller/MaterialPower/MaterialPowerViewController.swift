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
    
    @IBOutlet weak var dataView: UIScrollView!
    
    class func instantiateFromStoryboard() -> MaterialPowerViewController {
        let storyboard = UIStoryboard(name: "MaterialPower", bundle: nil)
        return storyboard.instantiateViewControllerWithIdentifier(String(self)) as! MaterialPowerViewController
    }

    private var dailyMaterialPowerView: DailyMaterialPowerView?
    private var materialPowerView: MaterialPowerView?
    private var operationView: OperationView?
    
    private let getDataGroup = dispatch_group_create()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Observing notifications
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.handleNotification(_:)), name: DataSearchNotification, object: nil)
        
        //
        // Daily Material Power View Section
        //
        if self.dailyMaterialPowerView == nil {
            self.dailyMaterialPowerView = (NSBundle.mainBundle().loadNibNamed("DailyMaterialPowerView", owner: self, options: nil).last as! DailyMaterialPowerView
            )
        }
        getDailyMaterialPowerData()

        //
        // Material Power View Section
        //
        if self.materialPowerView == nil {
            self.materialPowerView = (NSBundle.mainBundle().loadNibNamed("MaterialPowerView", owner: self, options: nil).last as! MaterialPowerView
            )
        }
        getMaterialPowerData()
        
        //
        // Operation View Section
        //
        if self.operationView == nil {
            self.operationView = (NSBundle.mainBundle().loadNibNamed("OperationView", owner: self, options: nil).last as! OperationView
            )
        }
        getOperationData()

    }
    
    override func viewWillAppear(animated: Bool) {
        
        dispatch_group_notify(getDataGroup, dispatch_get_main_queue()) {
            super.viewWillAppear(animated)
            self.arrangeMaterialPowerView(self).layoutIfNeeded()
        }

    }
    
    func handleNotification(notification: NSNotification) -> Void {
        
        getDailyMaterialPowerData()
        getMaterialPowerData()
        getOperationData()
        
        dispatch_group_notify(getDataGroup, dispatch_get_main_queue()) {
            self.arrangeMaterialPowerView(self).layoutIfNeeded()
        }
    }
    
    func getDailyMaterialPowerData() {
        
        dispatch_group_enter(getDataGroup)
        
        DailyMaterialPower.get(date: SearchParameter["date"]!, lNo: SearchParameter["lNo"]!) { (response: WISValueResponse<JSON>) in
            if response.success {
                self.dailyMaterialPowerView!.dailyMaterialPowerContentJSON = response.value!
                self.dailyMaterialPowerView!.drawTable()
                self.dataView.addSubview(self.dailyMaterialPowerView!)
            } else {
                wisError(response.message)
            }
            dispatch_group_leave(self.getDataGroup)
        }
        
    }
    
    func getMaterialPowerData() {
        
        dispatch_group_enter(getDataGroup)
        
        MaterialPower.get(date: SearchParameter["date"]!, shiftNo: SearchParameter["shiftNo"]!, lNo: SearchParameter["lNo"]!) { (response: WISValueResponse<JSON>) in
            if response.success {
                //                debugPrint(response.value)
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
                
                self.materialPowerView!.drawTable(switchRowCount, viewHeight: viewHeight)
                self.dataView.addSubview(self.materialPowerView!)
                
            } else {
                wisError(response.message)
            }
            
            dispatch_group_leave(self.getDataGroup)
        }
    }
    
    func getOperationData() {
        
        dispatch_group_enter(getDataGroup)
        
        Operation.get(date: SearchParameter["date"]!, shiftNo: SearchParameter["shiftNo"]!, lNo: SearchParameter["lNo"]!) { (response: WISValueResponse<JSON>) in
            if response.success {
                debugPrint(response.value!)
                let tableContentJSON = response.value!["Infos"].arrayValue
                print(tableContentJSON)
                self.operationView!.tableContentJSON = tableContentJSON
                
                var switchRowCount = [Int]()
                for i in 0 ..< tableContentJSON.count {
                    let switchContentJSON = tableContentJSON[i]["SwitchTimes"].arrayValue
                    self.operationView!.switchContentJSON.append(switchContentJSON)
                    
                    if switchContentJSON.count > 1 {
                        switchRowCount.append(switchContentJSON.count)
                    } else {
                        switchRowCount.append(1)
                    }
                }
                var totalRowCount = 0
                for count in switchRowCount {
                    totalRowCount += count
                }
                let viewHeight = CGFloat(totalRowCount) * DataTableBaseRowHeight + 60 + 35
                self.operationView!.viewHeight = viewHeight
                self.operationView!.drawTable(switchRowCount, viewHeight: viewHeight)
                self.dataView.addSubview(self.operationView!)
            } else {
                wisError(response.message)
            }
            
            dispatch_group_leave(self.getDataGroup)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        materialPowerViewController.dailyMaterialPowerView!.frame = CGRectMake(0.0, 0.0, self.dataView.bounds.size.width/*CURRENT_SCREEN_WIDTH*/, self.dailyMaterialPowerView!.viewHeight)
        materialPowerViewController.materialPowerView!.frame = CGRectMake(0.0, self.dailyMaterialPowerView!.viewHeight, self.dataView.bounds.size.width, self.materialPowerView!.viewHeight!)
        materialPowerViewController.operationView!.frame = CGRectMake(0.0, self.dailyMaterialPowerView!.viewHeight + self.materialPowerView!.viewHeight!, self.dataView.bounds.size.width, self.operationView!.viewHeight!)
        materialPowerViewController.dataView.contentSize = CGSizeMake(dataViewWidth, (self.dailyMaterialPowerView!.viewHeight + self.materialPowerView!.viewHeight! + self.operationView!.viewHeight!))
        
        return materialPowerViewController.view
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: DataSearchNotification, object: nil)
    }

}
