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

#if !RX_NO_MODULE
    import RxSwift
    import RxCocoa
#endif

class BoilerPurifyViewController: ViewController {

    @IBOutlet weak var dataView: UIScrollView!
    
    private var firstColumnView: UIView!
    private var scrollView: UIScrollView!
    private var firstColumnTableView: DataTableView!
    private var columnTableView = [DataTableView]()
    
    private var noDataView: NoDataView!
    
    private var hasRefreshedData = false
    
    private let rowCount: Int = 8
    
    private var tableContentJSON: [JSON] = []
    private var tableTitleJSON = JSON.null
    
//    private static let firstColumnViewWidth: CGFloat = 90
    
    class func instantiateFromStoryboard() -> BoilerPurifyViewController {
        let storyboard = UIStoryboard(name: "BoilerPurify", bundle: nil)
        return storyboard.instantiateViewControllerWithIdentifier(String(self)) as! BoilerPurifyViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // initialize No data View
        if self.noDataView == nil {
            self.noDataView = (NSBundle.mainBundle().loadNibNamed("NoDataView", owner: self, options: nil)!.last as! NoDataView
            )
        }
        
        hasRefreshedData = false
        
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
        let navigationBarHeight = self.navigationController?.navigationBar.bounds.height ?? CGFloat(40.0)
        let statusBarHeight = STATUS_BAR_HEIGHT
//        let menuHeaderHeight = CGFloat(35.0)
        
        let dataViewWidth = CURRENT_SCREEN_WIDTH
        let dataViewHeight = CURRENT_SCREEN_HEIGHT - navigationBarHeight - statusBarHeight - WISCommon.pageMenuHeaderHeight
        
        //
        // TBC: how to get row count?
        //
        let columnCount = BoilerPurify().propertyNames().count - 1
        
        // Draw view for first column
        firstColumnView = UIView(frame: CGRectMake(0, 0, WISCommon.firstColumnViewWidth, dataViewHeight))
        firstColumnView.backgroundColor = UIColor.whiteColor()
        //        headerView.userInteractionEnabled = true
        self.dataView.addSubview(firstColumnView)
        
        // Draw first column table
        firstColumnTableView = DataTableView(frame: firstColumnView.bounds, style: .Plain, rowInfo: nil)
        firstColumnTableView.dataTableDelegate = self
        firstColumnView.addSubview(firstColumnTableView)
        
        // Draw view for data table
        scrollView = UIScrollView(frame: CGRectMake (WISCommon.firstColumnViewWidth, 0, dataViewWidth - WISCommon.firstColumnViewWidth, dataViewHeight))
        scrollView.contentSize = CGSizeMake(CGFloat(columnCount) * WISCommon.DataTableColumnWidth, CGFloat(rowCount) * DataTableBaseRowHeight)
        scrollView.showsHorizontalScrollIndicator = true
        scrollView.showsVerticalScrollIndicator = true
        scrollView.bounces = true
        scrollView.delegate = self
        scrollView.backgroundColor = UIColor.whiteColor()
        self.dataView.addSubview(scrollView)
        
        // Draw data table
        var tableColumnsCount = 0
        for p in BoilerPurify().propertyNames() {
            if p == "Id" {
                continue
            } else {
                let tempColumnTableView = DataTableView(frame: CGRectMake(CGFloat(tableColumnsCount) * WISCommon.DataTableColumnWidth, 0, WISCommon.DataTableColumnWidth, dataViewHeight), style: .Plain, rowInfo: nil)
                self.columnTableView.append(tempColumnTableView)
                self.columnTableView[tableColumnsCount].dataTableDelegate = self
                self.scrollView.addSubview(self.columnTableView[tableColumnsCount])
                tableColumnsCount += 1
            }
        }
        
        // To get data row selected and segue to the dataDetailViewController
        var selectedElement = firstColumnTableView.selectedIndexPath.asObservable()
        
        for tableView in columnTableView {
            selectedElement = Observable.of(selectedElement, tableView.selectedIndexPath).merge()
        }
        
        var dataTitle: String = EMPTY_STRING        // title in the center of navigationbar in dataDetailView
        var dataContents: [String: String] = [:]    // data contents in dataDetailView
        
        //
        selectedElement
            .subscribeNext { [unowned self] rowIndex -> () in
//                print("tapped row number: \(rowIndex)")
                
                // Read title of record
                self.firstColumnTableView.viewModel.titleArraySubject
                    .asObservable()
                    .subscribeNext { titleArray in
                        guard rowIndex > -1 && rowIndex < titleArray.count else { return }
                        dataTitle = titleArray[rowIndex] ?? ""
                    }.addDisposableTo(self.disposeBag)
                
                var columnTitle: String?
                // Read detail data with title
                for column in self.columnTableView {
                    column.viewModel.titleArraySubject
                        .asObservable()
                        .subscribeNext { data in
                            guard rowIndex > -1 && rowIndex < data.count else { return }
                            columnTitle = self.tableTitleJSON["title"][column.title].stringValue ?? ""
                            dataContents[columnTitle!] = data[rowIndex] ?? ""
                        }.addDisposableTo(self.disposeBag)
                }
                
                // DataDetailViewController.performPushToDataDetailViewController(self, title: dataTitle, dataContents: dataContents, animated: true)
                
            }.addDisposableTo(disposeBag)
        
        dataView.mj_header = WISRefreshHeader {[weak self] () -> () in
            self?.headerRefresh()
        }
        
        // Get data for data table
        // getData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        arrangeBoilerPurifyView(self).layoutIfNeeded()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        // Get data for data table
        if !hasRefreshedData { getData() }
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
            self.arrangeBoilerPurifyView(self)
        }, completion: nil)
    }

    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: DataSearchNotification, object: nil)
    }
    
    private func arrangeBoilerPurifyView(boilerPurifyViewController: BoilerPurifyViewController) -> UIView {
        
        if boilerPurifyViewController.view.subviews.contains(boilerPurifyViewController.noDataView) {
            boilerPurifyViewController.noDataView.frame = boilerPurifyViewController.dataView.frame
        } else {
            let navigationBarHeight = self.navigationController?.navigationBar.bounds.height ?? NAVIGATION_BAR_HEIGHT
            let dataViewWidth = CURRENT_SCREEN_WIDTH
            let dataTableHeight = CGFloat(rowCount) * DataTableBaseRowHeight + DataTableHeaderRowHeight
            let blankScreenHeight = CURRENT_SCREEN_HEIGHT - navigationBarHeight - STATUS_BAR_HEIGHT - WISCommon.pageMenuHeaderHeight
            let dataViewHeight = dataTableHeight > blankScreenHeight ? dataTableHeight : blankScreenHeight
            
            boilerPurifyViewController.dataView.frame = CGRectMake(0, 0, CURRENT_SCREEN_WIDTH, dataViewHeight)
            boilerPurifyViewController.dataView.contentSize = CGSizeMake(CURRENT_SCREEN_WIDTH, dataViewHeight)
            
            boilerPurifyViewController.firstColumnView.frame = CGRectMake(0, 0, WISCommon.firstColumnViewWidth, dataViewHeight)
            boilerPurifyViewController.firstColumnTableView.frame = firstColumnView.bounds
            
            boilerPurifyViewController.scrollView.frame = CGRectMake(WISCommon.firstColumnViewWidth, 0, dataViewWidth - WISCommon.firstColumnViewWidth, dataViewHeight)
            
            // Draw data table
            //        var tableColumnsCount = 0
            //        for view in self.columnTableView {
            //            view.frame = CGRectMake(CGFloat(tableColumnsCount) * DataTableColumnWidth, 0, DataTableColumnWidth, dataViewHeight)
            //            tableColumnsCount += 1
            //        }
        }
        
        return boilerPurifyViewController.view
    }

    
    func getData() {
        SVProgressHUD.showWithStatus("数据获取中...")
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            BoilerPurify.get(date: SearchParameter["date"]!, shiftNo: SearchParameter["shiftNo"]!, lNo: SearchParameter["lNo"]!) { (response: WISValueResponse<[JSON]>) in
                
                // dispatch_async(dispatch_get_main_queue()) {
                    if response.success {
                        SVProgressHUD.setDefaultMaskType(.None)
                        SVProgressHUD.showSuccessWithStatus("数据获取成功！")
                        
                        self.noDataView.removeFromSuperview()
                        
                        self.dataView.addSubview(self.firstColumnView)
                        self.firstColumnView.addSubview(self.firstColumnTableView)
                        self.dataView.addSubview(self.scrollView)
                        
                        self.firstColumnTableView.viewModel.headerString = SearchParameter["date"]! + "\n" + getShiftName(SearchParameter["shiftNo"]!)[0]
                        var firstColumnTitleArray: [String] = []
                        for i in 0 ..< 8 {
                            firstColumnTitleArray.append(getShiftName(SearchParameter["shiftNo"]!)[i + 1])
                        }
                        self.firstColumnTableView.viewModel.titleArray = firstColumnTitleArray
                        self.firstColumnTableView.viewModel.titleArraySubject
                            .onNext(firstColumnTitleArray)
                        // self.firstColumnTableView.reloadData()
                        
                        self.tableContentJSON = response.value!
                        // self.firstColumnTableView.reloadData()
                        
                        var tableColumnsCount = 0
                        for p in BoilerPurify().propertyNames() {
                            if p == "Id" {
                                continue
                            } else {
                                // header
                                let columnTitle: String = self.tableTitleJSON["title"][p].stringValue
                                self.columnTableView[tableColumnsCount].title = p
                                self.columnTableView[tableColumnsCount].viewModel.headerString = columnTitle
                                self.columnTableView[tableColumnsCount].viewModel.headerStringSubject
                                    .onNext(columnTitle)
                                // content
                                var contentArray: [String] = []
                                for j in 0 ..< self.tableContentJSON.count {
                                    let content = self.tableContentJSON[j][p].stringValue.trimNumberFromFractionalPart(2)
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
                        self.hasRefreshedData = true
                        
                    } else {
                        self.noDataView.frame = self.dataView.frame
                        self.dataView.addSubview(self.noDataView)
                        
                        self.firstColumnView.removeFromSuperview()
                        self.firstColumnTableView.removeFromSuperview()
                        self.scrollView.removeFromSuperview()
                        
                        self.hasRefreshedData = false
                        wisError(response.message)
                    }
                }
            // }
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
