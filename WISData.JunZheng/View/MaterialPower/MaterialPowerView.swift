//
//  MaterialPowerView.swift
//  WISData.JunZheng
//
//  Created by Allen on 16/9/4.
//  Copyright © 2016 Wisdri. All rights reserved.
//

import UIKit
import SwiftyJSON
import SVProgressHUD

class MaterialPowerView: UIView {

    @IBOutlet weak var viewTitleLabel: UILabel!
    @IBOutlet weak var dataView: UIView!
    
    private var firstColumnView: UIView!
    private var scrollView: UIScrollView!
    private var firstColumnTableView: DataTableView!
    private var columnTableView = [DataTableView]()
    private var switchRowCount: Int = 1
    
    private var tableTitleJSON = JSON.null
    var tableContentJSON = JSON.null
    var switchContentJSON = [JSON]()
    var viewHeight: CGFloat = CGFloat(35.0)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // View setup
        self.backgroundColor = UIColor.whiteColor()
        self.viewTitleLabel.backgroundColor = UIColor.wisGrayColor().colorWithAlphaComponent(0.3)
    }
    
    func initialDrawTable(switchRowCount: Int, viewHeight: CGFloat) {

        self.switchRowCount = switchRowCount
        // Get table column title
        if let path = NSBundle.mainBundle().pathForResource("MaterialPowerTitle", ofType: "json") {
            let data = NSData(contentsOfFile: path)
            tableTitleJSON = JSON(data: data!)
        } else {
            tableTitleJSON = JSON.null
        }
        
        // Define the table dimensions
        let dataViewWidth = CURRENT_SCREEN_WIDTH
        let dataViewHeight = viewHeight - WISCommon.viewHeaderTitleHeight
//        let firstColumnViewWidth: CGFloat = 90

        // -2 是因为 KEY "No" 和 "SwithTimeReasons" 不作为表格列名
        let mpColumnCount = MaterialPower().propertyNames().count - 2
        // 电极切换数据
        let switchColumnCount = SwitchTimeReason().propertyNames().count
        let totalColumnCount = mpColumnCount + switchColumnCount
        
        // Draw view for first column
        firstColumnView = UIView(frame: CGRectMake(0, 0, WISCommon.firstColumnViewWidth, dataViewHeight))
        firstColumnView.backgroundColor = UIColor.whiteColor()
        //        headerView.userInteractionEnabled = true
        self.dataView.addSubview(firstColumnView)
        
        // Draw first column table
        firstColumnTableView = DataTableView(frame: firstColumnView.bounds, style: .Plain, rowInfo: [switchRowCount])
        firstColumnTableView.dataTableDelegate = self
        firstColumnView.addSubview(firstColumnTableView)
        
        // Draw view for data table
        scrollView = UIScrollView(frame: CGRectMake (WISCommon.firstColumnViewWidth, 0, dataViewWidth - WISCommon.firstColumnViewWidth, dataViewHeight))
        scrollView.contentSize = CGSizeMake(CGFloat(totalColumnCount) * WISCommon.DataTableColumnWidth, CGFloat(switchRowCount) * DataTableBaseRowHeight)
        scrollView.showsHorizontalScrollIndicator = true
        scrollView.showsVerticalScrollIndicator = true
        scrollView.bounces = true
        scrollView.delegate = self
        scrollView.backgroundColor = UIColor.whiteColor()
        self.dataView.addSubview(scrollView)
        
        // Draw data table
        var tableColumnsCount = 0
        for p in MaterialPower().propertyNames() {
            if p == "Remark" || p == "SwithTimeReasons" {
                continue
            } else {
                let tempColumnTableView = DataTableView(frame: CGRectMake(CGFloat(tableColumnsCount) * WISCommon.DataTableColumnWidth, 0, WISCommon.DataTableColumnWidth, dataViewHeight), style: .Plain, rowInfo: [switchRowCount])
                self.columnTableView.append(tempColumnTableView)
                self.columnTableView[tableColumnsCount].dataTableDelegate = self
                self.scrollView.addSubview(self.columnTableView[tableColumnsCount])
                tableColumnsCount += 1
            }
        }
        
        for _ in SwitchTimeReason().propertyNames() {
            let tempColumnTableView = DataTableView(frame: CGRectMake(CGFloat(tableColumnsCount) * WISCommon.DataTableColumnWidth, 0, WISCommon.DataTableColumnWidth, dataViewHeight), style: .Plain, rowInfo: nil)
            self.columnTableView.append(tempColumnTableView)
            self.columnTableView[tableColumnsCount].dataTableDelegate = self
            self.scrollView.addSubview(self.columnTableView[tableColumnsCount])
            tableColumnsCount += 1
        }
        
        fillDataTableContent()
    }
    
    func arrangeMaterialPowerSubView(viewHeight: CGFloat) {
        // Define the table dimensions
        let dataViewWidth = CURRENT_SCREEN_WIDTH
        let dataViewHeight = viewHeight - WISCommon.viewHeaderTitleHeight
//        let firstColumnViewWidth: CGFloat = 90
        
        guard let scrollView = self.scrollView else {
            return
        }
        scrollView.frame = CGRectMake(WISCommon.firstColumnViewWidth, 0, dataViewWidth - WISCommon.firstColumnViewWidth, dataViewHeight)
    }

    private func fillDataTableContent() {
        
        firstColumnTableView.viewModel.headerString = SearchParameter["date"]!
        var firstColumnTitleArray: [String] = []
        firstColumnTitleArray.append(getShiftName(SearchParameter["shiftNo"]!)[0])
        firstColumnTableView.viewModel.titleArray = firstColumnTitleArray
        self.firstColumnTableView.viewModel.titleArraySubject
            .onNext(firstColumnTitleArray)
        
        var tableColumnsCount = 0
        for p in MaterialPower().propertyNames() {
            if p == "Remark" || p == "SwithTimeReasons" {
                continue
            } else {
                // header
                let columnTitle: String = self.tableTitleJSON["title"][p].stringValue
                self.columnTableView[tableColumnsCount].viewModel.headerString = columnTitle
                // content
                var contentArray: [String] = []
                let content = self.tableContentJSON[p].stringValue.trimNumberFromFractionalPart(2)
                contentArray.append(content)

                self.columnTableView[tableColumnsCount].viewModel.titleArray = contentArray
                self.columnTableView[tableColumnsCount].viewModel.titleArraySubject.onNext(contentArray)
                // self.columnTableView[tableColumnsCount].reloadData()
                tableColumnsCount += 1
            }
        }
        for p in SwitchTimeReason().propertyNames() {
            // header
            let columnTitle: String = self.tableTitleJSON["title"]["SwithTimeReasons"][p].stringValue
            self.columnTableView[tableColumnsCount].viewModel.headerString = columnTitle
            // content
            var contentArray: [String] = []
            if self.switchContentJSON.count == 0 {
                contentArray.append(EMPTY_STRING)
            } else {
                for j in 0 ..< self.switchRowCount {
                    let content = self.switchContentJSON[j][p].stringValue
                    contentArray.append(content)
                }
            }
            self.columnTableView[tableColumnsCount].viewModel.titleArray = contentArray
            self.columnTableView[tableColumnsCount].viewModel.titleArraySubject
                .onNext(contentArray)
            tableColumnsCount += 1
        }
    }
}

// MARK: - Extension

extension MaterialPowerView: DataTableViewDelegate {
    
    func dataTableViewContentOffSet(contentOffSet: CGPoint) {
        
        for subView in scrollView.subviews {
            if subView.isKindOfClass(DataTableView) {
                (subView as! DataTableView).setTableViewContentOffSet(contentOffSet)
            }
        }
        
        for subView in firstColumnView.subviews {
            (subView as! DataTableView).setTableViewContentOffSet(contentOffSet)
        }
    }
}

extension MaterialPowerView: UIScrollViewDelegate {
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        //        let p: CGPoint = scrollView.contentOffset
        //        print(NSStringFromCGPoint(p))
    }
}
