//
//  WISHelper.swift
//  WISData.JunZheng
//
//  Created by Allen on 16/8/22.
//  Copyright © 2016 Wisdri. All rights reserved.
//

import Foundation
import SVProgressHUD

func println(@autoclosure item: () -> Any) {
    #if DEBUG
        Swift.print(item())
    #endif
}

func NSLocalizedString( key:String ) -> String {
    return NSLocalizedString(key, comment: EMPTY_STRING)
}

func wisFont(fontSize: CGFloat) -> UIFont {
    return UIFont.systemFontOfSize(fontSize)
}

func wisError(customInformation: String) {
    SVProgressHUD.setDefaultMaskType(.None)
    SVProgressHUD.showErrorWithStatus(customInformation)
}

typealias CancelableTask = (cancel: Bool) -> Void

func delay(time: NSTimeInterval, work: dispatch_block_t) -> CancelableTask? {
    
    var finalTask: CancelableTask?
    
    let cancelableTask: CancelableTask = { cancel in
        if cancel {
            finalTask = nil // key
            
        } else {
            dispatch_async(dispatch_get_main_queue(), work)
        }
    }
    
    finalTask = cancelableTask
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(time * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
        if let task = finalTask {
            task(cancel: false)
        }
    }
    
    return finalTask
}

func dateFormatterForSearch(date: NSDate) -> String {
    let formatter = NSDateFormatter()
    formatter.dateFormat = "yyyy/MM/dd"
    return formatter.stringFromDate(date)
}

/**
 向tableView 注册 UITableViewCell
 
 - parameter tableView: tableView
 - parameter cell:      要注册的类名
 */
//func regClass(tableView: UITableView, cell: AnyClass) -> Void {
//    tableView.registerClass(cell, forCellReuseIdentifier: cell.Identifier())
//}
/**
 从tableView缓存中取出对应类型的Cell
 如果缓存中没有，则重新创建一个
 
 - parameter tableView: tableView
 - parameter cell:      要返回的Cell类型
 - parameter indexPath: 位置
 
 - returns: 传入Cell类型的 实例对象
 */
func getCell<T: UITableViewCell>(tableView: UITableView, cell: T.Type, indexPath:NSIndexPath) -> T {
    return tableView.dequeueReusableCellWithIdentifier("\(cell)", forIndexPath: indexPath) as! T
}

func getShiftName(shiftNo: String) -> String {
    switch shiftNo {
    case "1":
        return "早班"
    case "2":
        return "中班"
    case "3":
        return "晚班"
    default:
        return "参数错误"
    }
}

func dispatch_sync_safely_main_queue(block: ()->()) {
    if NSThread.isMainThread() {
        block()
    } else {
        dispatch_sync(dispatch_get_main_queue()) {
            block()
        }
    }
}

func alignTextVerticalInTextView(textView: UITextView) {
    
    let size = textView.sizeThatFits(CGSizeMake(CGRectGetWidth(textView.bounds), CGFloat(MAXFLOAT)))
    
    var topoffset = (textView.bounds.size.height - size.height * textView.zoomScale) / 2.0
    topoffset = topoffset < 0.0 ? 0.0 : topoffset
    
    textView.contentOffset = CGPointMake(0, -topoffset)
}