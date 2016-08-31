//
//  BoilerPurifyViewController.swift
//  WISData.JunZheng
//
//  Created by Allen on 16/8/24.
//  Copyright © 2016 Wisdri. All rights reserved.
//

import UIKit
import SwiftyJSON
import SVProgressHUD

class BoilerPurifyViewController: UIViewController {

    @IBOutlet weak var dataView: UIView!
    
    private var firstColumnView: UIView!
    private var scrollView: UIScrollView!
    private var firstColumnTableView: DataTableView!
    private var columnTableView = [DataTableView]()
    
    private var tableContentJSON: Array = [JSON]()
    private var tableTitleJSON = JSON.null
    
    class func instantiateFromStoryboard() -> BoilerPurifyViewController {
        let storyboard = UIStoryboard(name: "BoilerPurify", bundle: nil)
        return storyboard.instantiateViewControllerWithIdentifier(String(self)) as! BoilerPurifyViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Observing notifications
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.handleNotification(_:)), name: DataSearchNotification, object: nil)
        
        // Get table column title
        if let path = NSBundle.mainBundle().pathForResource("BoilerPurifyTitle", ofType: "json") {
            let data = NSData(contentsOfFile: path)
            tableTitleJSON = JSON(data: data!)
        } else {
            tableTitleJSON = JSON.null
        }
        
        // Define the table dimensions
        //
        // TBC: handle screen rotation!!!!!
        //
        let dataViewWidth = SCREEN_WIDTH
        let dataViewHeight = SCREEN_HEIGHT - 64 - 35
        let firstColumnViewWidth: CGFloat = 90
        //
        // TBC: how to get row count?
        //
        let rowCount = 8
        let columnCount = BoilerPurify().propertyNames().count - 1
        
        // Draw view for first column
        firstColumnView = UIView(frame: CGRectMake(0, 0, firstColumnViewWidth, dataViewHeight))
        firstColumnView.backgroundColor = UIColor.clearColor()
        //        headerView.userInteractionEnabled = true
        self.dataView.addSubview(firstColumnView)
        
        // Draw first column table
        firstColumnTableView = DataTableView(frame: firstColumnView.bounds, style: .Plain)
        firstColumnTableView.dataTableDelegate = self
        firstColumnView.addSubview(firstColumnTableView)
        
        // Draw view for data table
        scrollView = UIScrollView(frame: CGRectMake (firstColumnViewWidth, 0, dataViewWidth - firstColumnViewWidth, dataViewHeight))
        scrollView.contentSize = CGSizeMake(CGFloat(columnCount) * DataTableColumnWidth, CGFloat(rowCount) * DataTableRowHeight)
        scrollView.showsHorizontalScrollIndicator = true
        scrollView.showsVerticalScrollIndicator = true
        scrollView.bounces = false
        scrollView.delegate = self
        scrollView.backgroundColor = UIColor.clearColor()
        self.dataView.addSubview(scrollView)
        
        // Draw data table
        var tableColumnsCount = 0
        for p in BoilerPurify().propertyNames() {
            if p == "Id" {
                continue
            } else {
                let tempColumnTableView = DataTableView(frame: CGRectMake(CGFloat(tableColumnsCount) * DataTableColumnWidth, 0, DataTableColumnWidth, dataViewHeight), style: .Plain)
                self.columnTableView.append(tempColumnTableView)
                self.columnTableView[tableColumnsCount].dataTableDelegate = self
                self.scrollView.addSubview(self.columnTableView[tableColumnsCount])
                tableColumnsCount += 1
            }
        }
        
        // Get data for data table
        getData()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getData() {
        
        SVProgressHUD.show()
        
        firstColumnTableView.headerString = SearchParameter["date"]! + "\n" + getShiftName(SearchParameter["shiftNo"]!)[0]
        let firstColumnTitleArray = NSMutableArray()
        for i in 0 ..< 8 {
            firstColumnTitleArray.addObject(getShiftName(SearchParameter["shiftNo"]!)[i + 1])
        }
        firstColumnTableView.titleArray = firstColumnTitleArray
        
        BoilerPurify.get(date: SearchParameter["date"]!, shiftNo: SearchParameter["shiftNo"]!, lNo: SearchParameter["lNo"]!) { (response: WISValueResponse<[JSON]>) in
            if response.success {
                SVProgressHUD.dismiss()
                self.tableContentJSON = response.value!
                self.firstColumnTableView.reloadData()
                
                var tableColumnsCount = 0
                for p in BoilerPurify().propertyNames() {
                    if p == "Id" {
                        continue
                    } else {
                        // header
                        let columnTitle: String = self.tableTitleJSON["title"][p].stringValue
                        self.columnTableView[tableColumnsCount].headerString = columnTitle
                        // content
                        let contentArray = NSMutableArray()
                        for j in 0 ..< self.tableContentJSON.count {
                            let content = self.tableContentJSON[j][p].stringValue
                            contentArray.addObject(content)
                        }
                        self.columnTableView[tableColumnsCount].titleArray = contentArray
                        
                        self.columnTableView[tableColumnsCount].reloadData()
                        tableColumnsCount += 1
                    }
                }
            } else {
                wisError(response.message)
            }
        }
    }
    
    func handleNotification(notification: NSNotification) -> Void {
        getData()
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

// MARK: - Extension

extension BoilerPurifyViewController: DataTableViewDelegate {
    
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

extension BoilerPurifyViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        //        let p: CGPoint = scrollView.contentOffset
        //        print(NSStringFromCGPoint(p))
    }
}
