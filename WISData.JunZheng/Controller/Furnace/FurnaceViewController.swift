//
//  FurnaceViewController.swift
//  WISData.JunZheng
//
//  Created by Allen on 16/8/24.
//  Copyright © 2016 Wisdri. All rights reserved.
//

import UIKit
import SwiftyJSON
import SVProgressHUD

#if !RX_NO_MODULE
    import RxSwift
    import RxCocoa
#endif


public let DataTableColumnWidth: CGFloat = 70.0

class FurnaceViewController: ViewController {

    @IBOutlet weak var dataView: UIView!
    
    private var firstColumnView: UIView!
    private var scrollView: UIScrollView!
    private var firstColumnTableView: DataTableView!
    private var columnTableView = [DataTableView]()
    
    private var rowCount: Int = 8
    
    private var tableContentJSON: Array = [JSON]()
    private var tableTitleJSON = JSON.null
    
    private static let firstColumnViewWidth: CGFloat = 95
    
    class func instantiateFromStoryboard() -> FurnaceViewController {
        let storyboard = UIStoryboard(name: "Furnace", bundle: nil)
        return storyboard.instantiateViewControllerWithIdentifier(String(self)) as! FurnaceViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Observing notifications
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.handleNotification(_:)), name: DataSearchNotification, object: nil)
        
        // Get table column title
        if let path = NSBundle.mainBundle().pathForResource("FurnaceTitle", ofType: "json") {
            let data = NSData(contentsOfFile: path)
            tableTitleJSON = JSON(data: data!)
        } else {
            tableTitleJSON = JSON.null
        }
        
        // Define the table dimensions
        // 
        // TBC: handle screen rotation!!!!!
        //
        let navigationBarHeight = self.navigationController?.navigationBar.bounds.height ?? CGFloat(40.0)
        let statusBarHeight = STATUS_BAR_HEIGHT
        let menuHeaderHeight = CGFloat(35.0)
        
        let dataViewWidth = CURRENT_SCREEN_WIDTH
        let dataViewHeight = CURRENT_SCREEN_HEIGHT - navigationBarHeight - statusBarHeight - menuHeaderHeight
        
        self.dataView.frame = CGRectMake(0, 0, dataViewWidth, dataViewHeight)
        
        // 
        // TBC: how to get row count?
        //
        let columnCount = Furnace().propertyNames().count - 1
        
        // Draw view for first column
        firstColumnView = UIView(frame: CGRectMake(0, 0, FurnaceViewController.firstColumnViewWidth, dataViewHeight))
        firstColumnView.backgroundColor = UIColor.clearColor()
//        headerView.userInteractionEnabled = true
        self.dataView.addSubview(firstColumnView)
        
        // Draw first column table
        firstColumnTableView = DataTableView(frame: firstColumnView.bounds, style: .Plain, rowInfo: nil)
        firstColumnTableView.dataTableDelegate = self
        firstColumnView.addSubview(firstColumnTableView)
        
        // Draw view for data table
        scrollView = UIScrollView(frame: CGRectMake (FurnaceViewController.firstColumnViewWidth, 0, dataViewWidth - FurnaceViewController.firstColumnViewWidth, dataViewHeight))
        scrollView.contentSize = CGSizeMake(CGFloat(columnCount) * DataTableColumnWidth, CGFloat(rowCount) * DataTableBaseRowHeight)
        scrollView.showsHorizontalScrollIndicator = true
        scrollView.showsVerticalScrollIndicator = true
        scrollView.bounces = true
        scrollView.delegate = self
        scrollView.backgroundColor = UIColor.clearColor()
        self.dataView.addSubview(scrollView)

        // Draw data table
        var tableColumnsCount = 0
        for p in Furnace().propertyNames() {
            if p == "Id" {
                continue
            } else {
                let tempColumnTableView = DataTableView(frame: CGRectMake(CGFloat(tableColumnsCount) * DataTableColumnWidth, 0, DataTableColumnWidth, dataViewHeight), style: .Plain, rowInfo: nil)
                self.columnTableView.append(tempColumnTableView)
                self.columnTableView[tableColumnsCount].dataTableDelegate = self
                self.scrollView.addSubview(self.columnTableView[tableColumnsCount])
                tableColumnsCount += 1
            }
        }
        
        // Get data for data table
        self.getData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func willAnimateRotationToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        arrangeFurnaceView(self).layoutIfNeeded()
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: DataSearchNotification, object: nil)
    }
    
    private func arrangeFurnaceView(furnaceViewController: FurnaceViewController) -> UIView {
        let navigationBarHeight = self.navigationController?.navigationBar.bounds.height ?? CGFloat(40.0)
        let statusBarHeight = STATUS_BAR_HEIGHT
        let menuHeaderHeight = CGFloat(35.0)
        
        let dataViewWidth = CURRENT_SCREEN_WIDTH
        let dataViewHeight = CURRENT_SCREEN_HEIGHT - navigationBarHeight - statusBarHeight - menuHeaderHeight
        
        furnaceViewController.dataView.frame = CGRectMake(0, 0, dataViewWidth, dataViewHeight)

        furnaceViewController.firstColumnView.frame = CGRectMake(0, 0, FurnaceViewController.firstColumnViewWidth, dataViewHeight)
        furnaceViewController.firstColumnTableView.frame = firstColumnView.bounds
        
        furnaceViewController.scrollView.frame = CGRectMake(FurnaceViewController.firstColumnViewWidth, 0, dataViewWidth - FurnaceViewController.firstColumnViewWidth, dataViewHeight)
        
        // Draw data table
        var tableColumnsCount = 0
        for view in self.columnTableView {
            view.frame = CGRectMake(CGFloat(tableColumnsCount) * DataTableColumnWidth, 0, DataTableColumnWidth, dataViewHeight)
            tableColumnsCount += 1
        }
        
        return furnaceViewController.view
    }
    
    
    func getData() {
        SVProgressHUD.show()
        
        dispatch_async(dispatch_get_main_queue()) {
            self.firstColumnTableView.viewModel.headerString = SearchParameter["date"]! + "\n" + getShiftName(SearchParameter["shiftNo"]!)[0]
            var firstColumnTitleArray: [String] = []
            for i in 0 ..< 8 {
                firstColumnTitleArray.append(getShiftName(SearchParameter["shiftNo"]!)[i + 1])
            }
            self.firstColumnTableView.viewModel.titleArray = firstColumnTitleArray
            
            self.firstColumnTableView.viewModel.titleArraySubject
                .onNext(firstColumnTitleArray)
            
            // self.firstColumnTableView.reloadData()
        }
        
        // Put time consuming network request on global queue
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            Furnace.get(date: SearchParameter["date"]!, shiftNo: SearchParameter["shiftNo"]!, lNo: SearchParameter["lNo"]!) { (response: WISValueResponse<[JSON]>) in
                // To make sure UI refreshing task runs on main queue
                dispatch_async(dispatch_get_main_queue()) {
                    if response.success {
                        SVProgressHUD.dismiss()
                        self.tableContentJSON = response.value!
                        // self.firstColumnTableView.reloadData()
                        
                        var tableColumnsCount = 0
                        for p in Furnace().propertyNames() {
                            if p == "Id" {
                                continue
                                
                            } else {
                                // header
                                let columnTitle: String = self.tableTitleJSON["title"][p].stringValue
                                self.columnTableView[tableColumnsCount].viewModel.headerString = columnTitle
                                self.columnTableView[tableColumnsCount].viewModel.headerStringSubject
                                    .onNext(columnTitle)
                                // content
                                var contentArray: [String] = []
                                
                                for j in 0 ..< self.tableContentJSON.count {
                                    let content = self.tableContentJSON[j][p].stringValue
                                    contentArray.append(content)
                                }
                                if self.tableContentJSON.count < self.rowCount {
                                    for _ in self.tableContentJSON.count...(self.rowCount - 1) {
                                        contentArray.append("")
                                    }
                                }
                                
                                self.columnTableView[tableColumnsCount].viewModel.titleArray = contentArray
                                self.columnTableView[tableColumnsCount].viewModel.titleArraySubject
                                    .onNext(contentArray)
                                // self.columnTableView[tableColumnsCount].reloadData()
                                
                                tableColumnsCount += 1
                            }
                        }
                        
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension FurnaceViewController: DataTableViewDelegate {
    
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

extension FurnaceViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
//        let p: CGPoint = scrollView.contentOffset
//        print(NSStringFromCGPoint(p))
    }
}