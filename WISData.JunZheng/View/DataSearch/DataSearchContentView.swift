//
//  DataSearchContentView.swift
//  WISData.JunZheng
//
//  Created by Jingwei Wu on 6/1/16.
//  Copyright © 2016 Wisdri. All rights reserved.
//

import UIKit

class DataSearchContentView: UIView {
    
    let ShiftPickerContentViewID = "ShiftPickerContentView"
    let DataSearchButtonViewID = "DataSearchButtonView"
    let DatePickerViewID = "DatePickerView"
    
    var dataSearchWrapperView: UIScrollView!
    var shiftPickerContentView: ShiftPickerContentView!
    var datePickerView: DatePickerView!
    
    var dataSearchButtonView: UIView!
    
    weak var parentViewController: UIViewController?
    var delegate: DataSearchContentViewDelegate?
    
    var currentShiftSelection: ShiftType!
    
    init(frame: CGRect, parentViewController: UIViewController!) {
        super.init(frame: CGRectZero)
        
        self.parentViewController = currentDevice.isPad ? nil : parentViewController
        self.prepareView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func prepareView() {
        // Constants for initializing
        let dataSearchButtonViewHeight: CGFloat = 50
        
        let mainScreenBound = UIScreen.mainScreen().applicationFrame
        let navigationBarHeight = self.parentViewController?.navigationController?.navigationBar.bounds.height ?? NAVIGATION_BAR_HEIGHT
//        let tabBarHeight = self.parentViewController.tabBarController?.tabBar.frame.size.height
        let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.height
        
        let filterContentViewMaxHeight = mainScreenBound.height - (statusBarHeight + navigationBarHeight) - dataSearchButtonViewHeight
        let itemGapHeight: CGFloat = 2
        
        
        let refFrame = currentDevice.isPad ? CGRectMake(0.0, 0.0, 360.0, filterContentViewMaxHeight)
            : CGRectMake(0.0,
                         statusBarHeight + navigationBarHeight,
                         mainScreenBound.width,
                         filterContentViewMaxHeight)
        
        let shiftPickerContentViewHeight: CGFloat = 155
        let datePickerViewHeight: CGFloat = 180
        
        //
        // initial contents - in wrapper view
        //

        // When the device is not iPad and is in landscape orientation, the devicePortrait is false
        // While the UIViewController.interfaceOrientation is deprecated, don't know how to easily get the orientation
        var devicePortrait = true
        if currentDevice.isPad == false && UIDeviceOrientationIsLandscape(UIDevice.currentDevice().orientation) {
            devicePortrait = false
        }
        
        // ** Shift selection
        if self.shiftPickerContentView == nil {
            self.shiftPickerContentView = NSBundle.mainBundle().loadNibNamed(self.ShiftPickerContentViewID, owner: self, options: nil)!.last as! ShiftPickerContentView
        }
        if devicePortrait {
            self.shiftPickerContentView!.frame = CGRectMake(0.0, 0.0, refFrame.size.width, self.shiftPickerContentView!.viewHeight)
        } else {
            self.shiftPickerContentView!.frame = CGRectMake(0.0, 0.0, refFrame.size.width / 2, shiftPickerContentViewHeight)
        }
//        self.shiftPickerContentView.bindData(currentGroupSelection)
        
        // add date picker
        self.datePickerView = NSBundle.mainBundle().loadNibNamed(self.DatePickerViewID, owner: self, options: nil)!.last as! DatePickerView
        
        if devicePortrait {
            self.datePickerView.frame =  CGRectMake(refFrame.origin.x, shiftPickerContentView!.viewHeight - 1, refFrame.size.width, datePickerViewHeight)
        } else {
            self.datePickerView.frame =  CGRectMake(refFrame.size.width / 2, 0, refFrame.size.width / 2, shiftPickerContentViewHeight)
        }
        
        // ** content wrapper
        var contentHeight, wrapperHeight: CGFloat?
        
        if devicePortrait {
            contentHeight = currentDevice.isPad ? (self.shiftPickerContentView.bounds.size.height + self.datePickerView.bounds.size.height)
            : (self.shiftPickerContentView.frame.origin.x + self.shiftPickerContentView.bounds.size.height + self.datePickerView.bounds.size.height)
        
            wrapperHeight = currentDevice.isPad ? contentHeight! : min(contentHeight!, filterContentViewMaxHeight)
        } else {
            contentHeight = shiftPickerContentViewHeight
            wrapperHeight = contentHeight
        }
        
        if self.dataSearchWrapperView == nil {
            self.dataSearchWrapperView = UIScrollView.init(frame: CGRectZero)
        }
        self.dataSearchWrapperView.frame = CGRectMake(refFrame.origin.x, refFrame.origin.y, refFrame.size.width, wrapperHeight!)
        self.dataSearchWrapperView.scrollEnabled = true
        self.dataSearchWrapperView.bounces = true
        self.dataSearchWrapperView.indicatorStyle = .Default
        self.dataSearchWrapperView.showsVerticalScrollIndicator = true
        self.dataSearchWrapperView.backgroundColor = UIColor.whiteColor()
        self.dataSearchWrapperView.contentSize = CGSize(width: refFrame.width, height: contentHeight! + 2)

        
        //
        // initial button view
        //
        if self.dataSearchButtonView == nil {
            self.dataSearchButtonView = UIView(frame: CGRectZero)
        }
        let contentWrapperFrame = self.dataSearchWrapperView.frame
        let buttonViewX = contentWrapperFrame.origin.x
        let buttonViewY = contentWrapperFrame.origin.y + contentWrapperFrame.size.height + itemGapHeight
        
        self.dataSearchButtonView.frame = CGRectMake(buttonViewX, buttonViewY, contentWrapperFrame.size.width, dataSearchButtonViewHeight)
        
        
        let okButton = UIButton(type: .System)
        okButton.frame = CGRectMake(self.dataSearchButtonView!.frame.size.width / 2, 0.0, self.dataSearchButtonView!.frame.size.width / 2, dataSearchButtonViewHeight)
        okButton.backgroundColor = UIColor.wisLogoColor().colorWithAlphaComponent(0.8)
        okButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        okButton.setTitle(NSLocalizedString("OK", comment: ""), forState: .Normal)
        okButton.titleLabel?.font = UIFont.systemFontOfSize(17)
        // okButton.autoresizingMask = .FlexibleWidth
        okButton.tag = ButtonType.OK.rawValue
        okButton.addTarget(self, action: #selector(self.buttonPressed(_:)), forControlEvents: .TouchUpInside)
        
        let cancelButton = UIButton(type: .System)
        cancelButton.frame = CGRectMake(0.0, 0.0, self.dataSearchButtonView!.frame.size.width / 2, dataSearchButtonViewHeight)
        cancelButton.backgroundColor = UIColor.whiteColor()
        cancelButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        cancelButton.setTitle(NSLocalizedString("Cancel", comment: ""), forState: .Normal)
        // cancelButton.titleLabel?.adjustsFontSizeToFitWidth = false
        cancelButton.titleLabel?.font = UIFont.systemFontOfSize(17)
        // cancelButton.autoresizingMask = .FlexibleWidth
        cancelButton.tag = ButtonType.Cancel.rawValue
        cancelButton.addTarget(self, action: #selector(self.buttonPressed(_:)), forControlEvents: .TouchUpInside)
        
        //
        // initial content view
        //
        let additionHeight = currentDevice.isPad ? CGFloat(0.0) : (statusBarHeight + navigationBarHeight)
        self.frame = CGRectMake(0.0, 0.0, refFrame.size.width, (self.dataSearchWrapperView?.frame.size.height)! + itemGapHeight + dataSearchButtonViewHeight + additionHeight)
        self.backgroundColor = UIColor.whiteColor()
        
        // add views
        if self.dataSearchWrapperView?.subviews.count > 0 {
            self.dataSearchWrapperView?.removeAllSubviews()
        }
        
        if self.dataSearchButtonView?.subviews.count > 0 {
            self.dataSearchButtonView?.removeAllSubviews()
        }
        
        if self.subviews.count > 0 {
            self.removeAllSubviews()
        }
        
        self.addSubview(self.dataSearchWrapperView!)
        self.addSubview(self.dataSearchButtonView!)
        
        self.dataSearchWrapperView!.addSubview(self.shiftPickerContentView!)
        self.dataSearchWrapperView!.addSubview(self.datePickerView!)
        self.dataSearchButtonView?.addSubview(okButton)
        self.dataSearchButtonView?.addSubview(cancelButton)
        
        self.layoutIfNeeded()
        
    }
    
    func buttonPressed(sender: UIButton) {
        guard self.delegate != nil else {
            return
        }
        
        let buttonType: ButtonType = ButtonType(rawValue: (sender as UIButton).tag)!
        
        switch buttonType {
        case .OK:
            SearchParameter["date"] = dateFormatterForSearch(self.datePickerView.searchDatePicker.date)
            SearchParameter["shiftNo"] = ShiftType(rawValue: shiftPickerContentView.currentSelectedIndexPath.row)!.getShiftNoForSearch
//            print(SearchParameter)
            let notification = NSNotification(name: DataSearchNotification, object: nil)
            NSNotificationCenter.defaultCenter().postNotification(notification)
            self.delegate?.contentViewConfirmed()
        case .Cancel:
            self.delegate?.contentViewCancelled()
        }
    }
    
    enum ButtonType: Int {
        case OK = 0
        case Cancel = 1
    }
}

protocol DataSearchContentViewDelegate {
    func contentViewConfirmed() -> Void
    func contentViewCancelled() -> Void
}
