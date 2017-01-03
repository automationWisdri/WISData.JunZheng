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
    var dailyMaterialPowerContentJSON = JSON.null

    static let defaultViewHeight = CGFloat(185)
    
    var viewHeight: CGFloat = CGFloat(185)
    
    override func awakeFromNib() {
        super.awakeFromNib()

        // Get table column title
        if let path = NSBundle.mainBundle().pathForResource("MaterialPowerTitle", ofType: "json") {
            let data = NSData(contentsOfFile: path)
            dailyMaterialPowerTitleJSON = JSON(data: data!)
        } else {
            dailyMaterialPowerTitleJSON = JSON.null
        }
        
        self.backgroundColor = UIColor.whiteColor()
        
        dailyMaterialPowerTable.dataSource = self
        dailyMaterialPowerTable.delegate = self
        dailyMaterialPowerTable.estimatedRowHeight = DataTableBaseRowHeight
        dailyMaterialPowerTable.separatorStyle = .None
        dailyMaterialPowerTable.scrollsToTop = false
        
        dailyMaterialPowerTable.registerNib(UINib(nibName: dailyMaterialPowerCellID, bundle: nil), forCellReuseIdentifier: dailyMaterialPowerCellID)
    }
    
    func initialDrawTable() {
        var i = 0
        var j = 0
        var key = EMPTY_STRING
        
        for p in DailyMaterialPower().propertyNames() {
            if p == "Result" {
                continue
            } else {
                key = String(i) + String(j)
                let tempTitle = self.dailyMaterialPowerTitleJSON["title"][p].stringValue
                let title = tempTitle.stringByReplacingOccurrencesOfString("\n", withString: " ")
                self.dailyMaterialPowerContent[key] = title
                
                j += 1
                key = String(i) + String(j)
                let content = self.dailyMaterialPowerContentJSON[p].stringValue.trimNumberFromFractionalPart(2)
                self.dailyMaterialPowerContent[key] = content
                j += 1
                
                if j == 4 {
                    i += 1
                    j = 0
                }
            }
        }
        
        dispatch_async(dispatch_get_main_queue()) {
            self.dailyMaterialPowerTable.reloadData()
        }
    }
    
    func arrangeDailyMaterialPowerSubView(viewHeight: CGFloat) {
        // do nothing so far
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
        
        let cell = getTableViewCell(tableView, cell: DailyMaterialPowerCell.self, indexPath: indexPath)
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
        return DataTableBaseRowHeight
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "全天消耗"
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return WISCommon.viewHeaderTitleHeight
    }
    
    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = UIColor.wisGrayColor().colorWithAlphaComponent(0.3)
        let headerView = view as! UITableViewHeaderFooterView
        headerView.textLabel?.font = UIFont.systemFontOfSize(16)
    }
}
