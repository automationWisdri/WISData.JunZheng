//
//  DataTableView.swift
//  WISData.JunZheng
//
//  Created by Allen on 16/8/23.
//  Copyright © 2016 Wisdri. All rights reserved.
//

import UIKit

protocol DataTableViewDelegate {
    func dataTableViewContentOffSet(contentOffSet: CGPoint)
}

class DataTableView: UITableView {

    var dataTableDelegate: DataTableViewDelegate!
    var titleArray = NSMutableArray()
    var headerString: String = ""
//    var levels = NSMutableArray()
    
    private let DataTableCellID = "DataTableCell"
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style:style)
        
        setupViews()
        
        self.registerNib(UINib(nibName: DataTableCellID, bundle: nil), forCellReuseIdentifier: DataTableCellID)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        self.delegate = self
        self.dataSource = self
        self.showsVerticalScrollIndicator = false //竖直
        self.backgroundColor = UIColor.clearColor()
        self.separatorStyle = .None //去掉分割线
        self.bounces = false
        self.rowHeight = 30
    }
    
    func setTableViewContentOffSet(contentOffset:CGPoint) {
        self.setContentOffset(contentOffset, animated: false)
    }
}

// MARK: - UITableView Delegate & DataSource

extension DataTableView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let identify = "CELL"
//        var cell = tableView.dequeueReusableCellWithIdentifier(identify)
//        if (cell == nil) {
//            cell = UITableViewCell(style: .Default, reuseIdentifier: identify)
//            cell?.backgroundColor = UIColor.clearColor()
//            
//            // 设置边框，形成表格
//            cell?.layer.borderWidth = 0.3
//            cell?.layer.borderColor = UIColor.blackColor().CGColor
//            // 取消选中
//            cell?.selectionStyle = .None
//            
//            let label = UILabel(frame: CGRectMake (10, 0, self.frame.size.width, 50))
//            label.tag = 100
//            cell?.contentView.addSubview(label)
//        }
//        
//        let label: UILabel = (cell?.contentView.viewWithTag(100) as! UILabel)
//        label.text = titleArray[indexPath.row] as? String
//        label.textColor = UIColor.blackColor()
        
        let cell = getCell(tableView, cell: DataTableCell.self, indexPath: indexPath)
        cell.dataTextView.text = titleArray[indexPath.row] as? String
//        // 分级
//        if levels.count > 0 {
//            let level = levels[indexPath.row] as? String
//            if level == "1" {
//                var frame:CGRect = label.frame
//                frame.origin.x = 10
//                label.frame = frame
//            }
//            else if level == "2" {
//                var frame:CGRect = label.frame
//                frame.origin.x = 30
//                label.frame = frame
//            }
//            else if level == "3" {
//                var frame:CGRect = label.frame
//                frame.origin.x = 50
//                label.frame = frame
//            }
//        }
        return cell
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UITableViewHeaderFooterView(frame: CGRectMake (0, 0, 95, 45))
        headerView.contentView.backgroundColor = UIColor.wisGroupHeaderColor()

        let headerTextView = UITextView(frame: CGRect(x: 0, y: 0, width: headerView.bounds.width, height: headerView.bounds.height - 1))
        headerTextView.text = self.headerString
        headerTextView.textColor = UIColor.blackColor()
        headerTextView.font = wisFont(12)
        headerTextView.backgroundColor = UIColor.clearColor()
        headerTextView.textAlignment = .Center
        alignTextVerticalInTextView(headerTextView)
        headerTextView.userInteractionEnabled = false
        debugPrint(headerView.bounds)
        debugPrint(headerTextView.text)
        debugPrint(headerTextView.bounds)
        headerView.addSubview(headerTextView)
        
        let bottomLineView = HorizontalLineView(frame: CGRect(x: 0, y: headerView.bounds.height - 1, width: headerView.bounds.width, height: 1))
        headerView.addSubview(bottomLineView)
        
//        headerView.layer.borderColor = UIColor.whiteColor().CGColor
//        headerView.layer.borderWidth = 0.3
        
        return headerView
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
}

// MARK: - UIScrollView delegate
extension DataTableView: UIScrollViewDelegate {
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        dataTableDelegate?.dataTableViewContentOffSet(scrollView.contentOffset)
    }
}

