//
//  FurnaceViewController.swift
//  WISData.JunZheng
//
//  Created by Allen on 16/8/24.
//  Copyright © 2016 Wisdri. All rights reserved.
//

import UIKit
import SwiftyJSON
import MJExtension

public let DataSearchNotification = "DataSearchNotification"

class FurnaceViewController: UIViewController {

    @IBOutlet weak var dataView: UIView!
    @IBOutlet weak var dataCommentLabel: UILabel!
    
    var arrY: Array = [JSON]()
    private var headerView: UIView!
    private var scrollView: UIScrollView!
    var tableTitleJSON = JSON.null
    
    class func instantiateFromStoryboard() -> FurnaceViewController {
        let storyboard = UIStoryboard(name: "Furnace", bundle: nil)
        return storyboard.instantiateViewControllerWithIdentifier(String(self)) as! FurnaceViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Observing notifications
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.handleNotification(_:)), name: DataSearchNotification, object: nil)
        
        let path = NSBundle.mainBundle().pathForResource("FurnaceTitle", ofType: "json")
        if (path != nil) {
            let data = NSData(contentsOfFile: path!)
            let json = JSON(data:data!)
            tableTitleJSON = json
            print("tableTitleJSON = \(tableTitleJSON)")
        } else {
            tableTitleJSON = JSON.null
        }
        
        let dataViewWidth = SCREEN_WIDTH
        let dataViewHeight = SCREEN_HEIGHT - 20 - 64 - 35
        let headerViewWidth: CGFloat = 95
        let rowCount = 8
        let columnCount = 3
        
        // Draw row header
        headerView = UIView(frame: CGRectMake(0, 0, headerViewWidth, dataViewHeight))
        headerView.backgroundColor = UIColor.clearColor()
        headerView.userInteractionEnabled = true
        // 设置边框，形成表格
//        headerView.layer.borderWidth = 0.5
//        headerView.layer.borderColor = UIColor.clearColor().CGColor
        self.dataView.addSubview(headerView)
        
        // 可左右滑动 tableView 父视图
        scrollView = UIScrollView(frame: CGRectMake (headerViewWidth, 0, dataViewWidth - headerViewWidth, dataViewHeight))
        scrollView.contentSize = CGSizeMake((CGFloat)(columnCount) * 95, CGFloat(rowCount * 30))
        scrollView.showsHorizontalScrollIndicator = true
        scrollView.showsVerticalScrollIndicator = true
        scrollView.bounces = false
        scrollView.delegate = self
        scrollView.backgroundColor = UIColor.clearColor()
        //设置边框，形成表格
//        scrollView.layer.borderColor = UIColor.clearColor().CGColor
//        scrollView.layer.borderWidth = 0.5
        self.dataView.addSubview(scrollView)
        
        // 第一列表
        let tableView: DataTableView = DataTableView(frame: headerView.bounds, style: .Plain)
        
        let titleArr1 = NSMutableArray()
//        let levels = NSMutableArray()
        for i in 0 ..< rowCount {
            titleArr1.addObject("\(i)")
        }
//        for var dic in arrY {
//            let titleStr = dic["date1"].stringValue
//            titleArr1.addObject(titleStr)
//            
//            let level = dic["table_level"].stringValue
//            levels.addObject(level)
//        }
//        
        tableView.titleArray = titleArr1
//        tableView.levels = levels
        
        tableView.headerString = SearchParameter["date"]! + "\n" + getShiftName(SearchParameter["shiftNo"]!)
        
        tableView.dataTableDelegate = self
        headerView.addSubview(tableView)
        
//        var furnaceArray = [Furnace]()
        
//        let tableColumns = Furnace().propertyNames().count
        // Get data
        Furnace.get(date: SearchParameter["date"]!, shiftNo: SearchParameter["shiftNo"]!, lNo: SearchParameter["lNo"]!) { (response: WISValueResponse<[JSON]>) in
            if response.success {
                self.dataCommentLabel.text = "查询参数：" + SearchParameter["date"]! + " | " + getShiftName(SearchParameter["shiftNo"]!) + " | " + SearchParameter["lNo"]! + "#炉"
                //                self.dataTextView.text = response.value
                self.arrY = response.value!
                //                debugPrint(self.arrY)
                
                var tableColumns = 0
                
                for p in Furnace().propertyNames() {
                    
                    if p == "Id" {
                        continue
                    } else {

                        let tableV: DataTableView = DataTableView(frame: CGRectMake(CGFloat(95 * tableColumns), 0, 95, SCREEN_HEIGHT - 20 - 64), style: .Plain)
                        
                        //x方向 取出key对应的字符串名字
                        let xkey: String = p
                        let xname: String = self.tableTitleJSON["title"][xkey].stringValue
                        
                        debugPrint(xname)
                        
                        //y方向
                        let titleArr2 = NSMutableArray()
                        for j in 0 ..< self.arrY.count {
                            let ykey = p
                            let yname = self.arrY[j][ykey].stringValue
                            debugPrint(yname)
                            titleArr2.addObject(yname)
                        }
                        
                        tableV.titleArray = titleArr2
                        tableV.headerString = xname
                        tableV.dataTableDelegate = self
//                        tableV.reloadData()
                        self.scrollView.addSubview(tableV)
                        
                        tableColumns += 1
                    }
                }
                
                
            } else {
                wisError(response.message)
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getData() {
        
        Furnace.get(date: SearchParameter["date"]!, shiftNo: SearchParameter["shiftNo"]!, lNo: SearchParameter["lNo"]!) { (response: WISValueResponse<[JSON]>) in
            if response.success {
                self.dataCommentLabel.text = "查询参数：" + SearchParameter["date"]! + " | " + getShiftName(SearchParameter["shiftNo"]!) + " | " + SearchParameter["lNo"]! + "#炉"
//                self.dataTextView.text = response.value
                self.arrY = response.value!
//                debugPrint(self.arrY)
            } else {
                wisError(response.message)
            }
        }
    }
    
    func handleNotification(notification: NSNotification) -> Void {
//        getData()
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
        
        for subView in headerView.subviews {
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