//
//  DailyMaterialPowerView.swift
//  WISData.JunZheng
//
//  Created by Allen on 16/9/1.
//  Copyright © 2016 Wisdri. All rights reserved.
//

import UIKit
import SwiftyJSON
import SVProgressHUD

class DailyMaterialPowerView: UIView {
    
    private let dailyMaterialPowerCellID = "DailyMaterialPowerCell"

    @IBOutlet weak var dailyMaterialPowerTable: UITableView!
    
    private var dailyMaterialPowerContent = [String : String]()
    private var dailyMaterialPowerTitleJSON = JSON.null
    private var dailyMaterialPowerContentJSON = JSON.null
    
    private var dailyMaterialPower = DailyMaterialPower()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Observing notifications
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.handleNotification(_:)), name: DataSearchNotification, object: nil)
        
        // Get table column title
        if let path = NSBundle.mainBundle().pathForResource("MaterialPowerTitle", ofType: "json") {
            let data = NSData(contentsOfFile: path)
            dailyMaterialPowerTitleJSON = JSON(data: data!)
        } else {
            dailyMaterialPowerTitleJSON = JSON.null
        }
        
        self.backgroundColor = UIColor.clearColor()
        
        dailyMaterialPowerTable.dataSource = self
        dailyMaterialPowerTable.delegate = self
        dailyMaterialPowerTable.estimatedRowHeight = 30
        dailyMaterialPowerTable.separatorStyle = .None
        dailyMaterialPowerTable.scrollsToTop = false
        
        dailyMaterialPowerTable.registerNib(UINib(nibName: dailyMaterialPowerCellID, bundle: nil), forCellReuseIdentifier: dailyMaterialPowerCellID)
        
        self.getData()
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: DataSearchNotification, object: nil)
    }
    
    func getData() {
        SVProgressHUD.showWithStatus("数据获取中...")
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            DailyMaterialPower.get(date: SearchParameter["date"]!, lNo: SearchParameter["lNo"]!) { (response: WISValueResponse<JSON>) in
                dispatch_async(dispatch_get_main_queue()) {
                    if response.success {
                        SVProgressHUD.showWithMaskType(.None)
                        SVProgressHUD.showSuccessWithStatus("数据获取成功！")
                        
                        self.dailyMaterialPowerContentJSON = response.value!
                        
                        // Daily Material Power part
                        
                        var i = 0
                        var j = 0
                        var key = EMPTY_STRING
                        for p in DailyMaterialPower().propertyNames() {
                            if p == "Result" {
                                continue
                            } else {
                                key = String(i) + String(j)
                                let title = self.dailyMaterialPowerTitleJSON["title"][p].stringValue
                                self.dailyMaterialPowerContent[key] = title
                                debugPrint("key is \(key), and value is \(title)")
                                
                                j += 1
                                key = String(i) + String(j)
                                let content = self.dailyMaterialPowerContentJSON[p].stringValue
                                self.dailyMaterialPowerContent[key] = content
                                debugPrint("key is \(key), and value is \(content)")
                                j += 1
                                
                                if j == 4 {
                                    i += 1
                                    j = 0
                                }
                            }
                        }
                        
                        self.dailyMaterialPowerTable.reloadData()
                        
                    } else {
                        wisError(response.message)
                    }
                }
            }
        }
    }
    
    func handleNotification(notification: NSNotification) -> Void {
        getData()
    }

}

extension DailyMaterialPowerView: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = getCell(tableView, cell: DailyMaterialPowerCell.self, indexPath: indexPath)
        var key = EMPTY_STRING
        
        switch indexPath.row {
        case 0, 1, 2, 3, 4:
            key = String(indexPath.row) + "0"
            cell.firstTitleLabel.text = self.dailyMaterialPowerContent[key]
            key = String(indexPath.row) + "1"
            cell.firstContentLabel.text = self.dailyMaterialPowerContent[key]
            key = String(indexPath.row) + "2"
            cell.secondTitleLabel.text = self.dailyMaterialPowerContent[key]
            key = String(indexPath.row) + "3"
            cell.secondContentLabel.text = self.dailyMaterialPowerContent[key]
            return cell
        default:
            return cell
        }

    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 30
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "全天消耗"
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
}
