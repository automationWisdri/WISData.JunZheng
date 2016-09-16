//
//  OperationView.swift
//  WISData.JunZheng
//
//  Created by Allen on 16/9/6.
//  Copyright © 2016 Wisdri. All rights reserved.
//

import UIKit
import SwiftyJSON

class OperationView: UIView {

    @IBOutlet weak var viewTitleLabel: UILabel!
    @IBOutlet weak var dataView: UIView!
    
    private var firstColumnView: UIView!
    private var scrollView: UIScrollView!
    private var firstColumnTableView: DataTableView!
    private var columnTableView = [DataTableView]()
    private var switchRowCount = [Int]()
    private var totalRowCount = 0
    
    private var tableTitleJSON = JSON.null
    var tableContentJSON = [JSON]()
    var switchContentJSON = [[JSON]]()
    var viewHeight: CGFloat = CGFloat(0.0)

    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Basic setup
        self.backgroundColor = UIColor.whiteColor()
        self.viewTitleLabel.backgroundColor = UIColor.wisGrayColor().colorWithAlphaComponent(0.3)
    }
    
    func initialDrawTable(switchRowCount: [Int], viewHeight: CGFloat) {
        self.switchRowCount = switchRowCount
        self.totalRowCount = switchRowCount.reduce(0, combine: + )
        
        // Get table column title
        if let path = NSBundle.mainBundle().pathForResource("OperationTitle", ofType: "json") {
            let data = NSData(contentsOfFile: path)
            tableTitleJSON = JSON(data: data!)
        } else {
            tableTitleJSON = JSON.null
        }
        
        // Define the table dimensions
        let dataViewWidth = CURRENT_SCREEN_WIDTH
        let dataViewHeight = viewHeight
        let firstColumnViewWidth: CGFloat = 90
        
        let opColumnCount = Operation().propertyNames().count - 2
        let switchColumnCount = SwitchTime().propertyNames().count
        let totalColumnCount = opColumnCount + switchColumnCount
        
        // Draw view for first column
        firstColumnView = UIView(frame: CGRectMake(0, 0, firstColumnViewWidth, dataViewHeight))
        firstColumnView.backgroundColor = UIColor.whiteColor()
        //        headerView.userInteractionEnabled = true
        self.dataView.addSubview(firstColumnView)
        
        // Draw first column table
        firstColumnTableView = DataTableView(frame: firstColumnView.bounds, style: .Plain, rowInfo: switchRowCount)
        firstColumnTableView.dataTableDelegate = self
        firstColumnView.addSubview(firstColumnTableView)
        
        // Draw view for data table
        scrollView = UIScrollView(frame: CGRectMake (firstColumnViewWidth, 0, dataViewWidth - firstColumnViewWidth, dataViewHeight))
        scrollView.contentSize = CGSizeMake(CGFloat(totalColumnCount) * DataTableColumnWidth, DataTableHeaderRowHeight + CGFloat(totalRowCount) * DataTableBaseRowHeight)
        scrollView.showsHorizontalScrollIndicator = true
        scrollView.showsVerticalScrollIndicator = true
        scrollView.bounces = false
        scrollView.delegate = self
        scrollView.backgroundColor = UIColor.whiteColor()
        self.dataView.addSubview(scrollView)
        
        // Draw data table
        self.columnTableView.removeAll()
        var tableColumnsCount = 0
        for p in Operation().propertyNames() {
            if p == "No" || p == "SwitchTimes" {
                continue
            } else {
                let tempColumnTableView = DataTableView(frame: CGRectMake(CGFloat(tableColumnsCount) * DataTableColumnWidth, 0, DataTableColumnWidth, dataViewHeight), style: .Plain, rowInfo: switchRowCount)
                self.columnTableView.append(tempColumnTableView)
                self.columnTableView[tableColumnsCount].dataTableDelegate = self
                self.scrollView.addSubview(self.columnTableView[tableColumnsCount])
                tableColumnsCount += 1
            }
        }
        
        for _ in SwitchTime().propertyNames() {
            let tempColumnTableView = DataTableView(frame: CGRectMake(CGFloat(tableColumnsCount) * DataTableColumnWidth, 0, DataTableColumnWidth, dataViewHeight), style: .Plain, rowInfo: nil)
            self.columnTableView.append(tempColumnTableView)
            self.columnTableView[tableColumnsCount].dataTableDelegate = self
            self.scrollView.addSubview(self.columnTableView[tableColumnsCount])
            tableColumnsCount += 1
        }
        
        fillDataTableContent()
    }
    
    func arrangeOperationSubView(viewHeight: CGFloat) {
        // Define the table dimensions
        let dataViewWidth = CURRENT_SCREEN_WIDTH
        let dataViewHeight = viewHeight
        let firstColumnViewWidth: CGFloat = 90
        
        guard let scrollView = self.scrollView else {
            return
        }
        scrollView.frame = CGRectMake(firstColumnViewWidth, 0, dataViewWidth - firstColumnViewWidth, dataViewHeight)
    }
    
    private func fillDataTableContent() {
        
        firstColumnTableView.viewModel.headerString = SearchParameter["date"]! + "\n" + getShiftName(SearchParameter["shiftNo"]!)[0]
        let firstColumnTitleArray = DJName
        firstColumnTableView.viewModel.titleArray = firstColumnTitleArray
        self.firstColumnTableView.viewModel.titleArraySubject
            .onNext(firstColumnTitleArray)
        
        var tableColumnsCount = 0
        for p in Operation().propertyNames() {
            if p == "No" || p == "SwitchTimes" {
                continue
            } else {
                // header
                let columnTitle: String = self.tableTitleJSON["title"][p].stringValue
                self.columnTableView[tableColumnsCount].viewModel.headerString = columnTitle
                // content
                var contentArray: [String] = []
                
                for j in 0 ..< self.tableContentJSON.count {
                    let content = self.tableContentJSON[j][p].stringValue.trimNumberFromFractionalPart(2)
                    contentArray.append(content)
                }
                
                self.columnTableView[tableColumnsCount].viewModel.titleArray = contentArray
                self.columnTableView[tableColumnsCount].viewModel.titleArraySubject.onNext(contentArray)
                self.columnTableView[tableColumnsCount].reloadData()
                tableColumnsCount += 1
            }
        }
        for p in SwitchTime().propertyNames() {
            // header
            let columnTitle: String = self.tableTitleJSON["title"]["SwitchTimes"][p].stringValue
            self.columnTableView[tableColumnsCount].viewModel.headerString = columnTitle
            // content
            var contentArray: [String] = []
            
            for i in 0 ..< self.tableContentJSON.count {
                if self.switchContentJSON[i].count == 0 {
                    contentArray.append(EMPTY_STRING)
                } else {
                    for j in 0 ..< self.switchRowCount[i] {
                        let content = self.switchContentJSON[i][j][p].stringValue
                        contentArray.append(content)
                    }
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

extension OperationView: DataTableViewDelegate {
    
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

extension OperationView: UIScrollViewDelegate {
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        //        let p: CGPoint = scrollView.contentOffset
        //        print(NSStringFromCGPoint(p))
    }
}
