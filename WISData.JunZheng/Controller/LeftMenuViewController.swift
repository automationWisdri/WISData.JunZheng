//
//  LeftMenuTableViewController.swift
//  WISData.JunZheng
//
//  Created by Allen on 16/8/24.
//  Copyright © 2016 Wisdri. All rights reserved.
//

import UIKit
import SVProgressHUD

class LeftMenuViewController: UIViewController {
    
    private var selectedMenuItem = Int(SearchParameter["lNo"]!)! - 1
    private let leftMenuCellID = "LeftMenuCell"

    private var _tableView: UITableView!
    private var tableView: UITableView {
        get{
            if(_tableView != nil){
                return _tableView!
            }
            _tableView = UITableView()
            _tableView.backgroundColor = UIColor.clearColor()
            _tableView.estimatedRowHeight = 80
            _tableView.separatorStyle = .None
            _tableView.scrollsToTop = false
            
            _tableView.registerClass(LeftUserHeadCell.self, forCellReuseIdentifier: "LeftUserHeadCell")
            _tableView.registerNib(UINib(nibName: leftMenuCellID, bundle: nil), forCellReuseIdentifier: leftMenuCellID)
            
            _tableView.delegate = self
            _tableView.dataSource = self
            return _tableView!
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.wisLogoColor().colorWithAlphaComponent(0.7)
        
        self.view.addSubview(self.tableView)
        self.tableView.snp_makeConstraints{ (make) -> Void in
            make.right.bottom.left.equalTo(self.view)
            make.top.equalTo(self.view).offset(15)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tableView.selectRowAtIndexPath(NSIndexPath(forRow: selectedMenuItem, inSection: 1), animated: false, scrollPosition: .None)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation
     
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    }
    */
}

    // MARK: - Table view data source

extension LeftMenuViewController: UITableViewDelegate, UITableViewDataSource {
    
    private enum Section: Int {
        case User
        case Plant
        case Info
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return [1, 4, 2][section]
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = getTableViewCell(tableView, cell: LeftUserHeadCell.self, indexPath: indexPath)
            
            cell.avatarImageView.image = UIImage(named: "default_avatar_60")
            cell.userNameLabel.text = (NSUserDefaults.standardUserDefaults().objectForKey("username") as! String)
            
            return cell
        
        case 1:
            
            let cell = getTableViewCell(tableView, cell: LeftMenuCell.self, indexPath: indexPath)
            
            cell.annotationLabel.text = "\(indexPath.row + 1)#炉"
            cell.menuIconImageView.image = UIImage.imageUsedTemplateMode("icon_house")
            
            return cell
            
        case 2:
            
            let cell = getTableViewCell(tableView, cell: LeftMenuCell.self, indexPath: indexPath)
            cell.annotationLabel.text = ["关于", "退出"][indexPath.row]
            let names = ["icon_about", "icon_logout"]
            cell.menuIconImageView.image = UIImage.imageUsedTemplateMode(names[indexPath.row])
            cell.accessoryImageView.hidden = (indexPath.row == 1) ? true : false
            return cell
            
        default:
            return UITableViewCell()
        }
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        switch indexPath.section {
        case 0: return 95
        case 1, 2: return 50 + SEPARATOR_HEIGHT
        default: return 0
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0: return 0
        case 1, 2: return 1
        default: return 0
        }
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 1, 2:
            let view = UIView()
            view.backgroundColor = UIColor(white: 0.1, alpha: 0.3)
            return view
        default:
            return UIView()
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        switch indexPath.section {
            
        case Section.User.rawValue:
            return
            
        case Section.Plant.rawValue:
            
            print("did select row: \(indexPath.row)")
            
            if (indexPath.row == selectedMenuItem) {
                return
            }
            
            selectedMenuItem = indexPath.row
            
            SearchParameter["lNo"] = String(indexPath.row + 1)
            
            print(SearchParameter)
            let notification = NSNotification(name: DataSearchNotification, object: nil)
            NSNotificationCenter.defaultCenter().postNotification(notification)
            
            WISClient.sharedInstance.drawerController?.closeDrawerAnimated(true, completion: nil)
            
        case Section.Info.rawValue:
            
            defer {
                tableView.deselectRowAtIndexPath(indexPath, animated: true)
            }
            
            switch indexPath.row {
                
            case 0:
                // Push 后导航栏的透明度变了，待解决
                let aboutStoryboard = UIStoryboard(name: "About", bundle: nil)
                let aboutViewController = aboutStoryboard.instantiateInitialViewController()!
                WISClient.sharedInstance.centerNavigation?.pushViewController(aboutViewController, animated: true)
                WISClient.sharedInstance.drawerController?.closeDrawerAnimated(true, completion: nil)
                
            case 1:
                WISClient.sharedInstance.drawerController?.closeDrawerAnimated(true, completion: nil)
                WISAlert.confirmOrCancel(title: "通知", message: "您确定要退出吗？", confirmTitle: "是的", cancelTitle: "取消", inViewController: self, withConfirmAction: { () -> Void in
                    // HUD 弹出有延时，待解决
                    SVProgressHUD.show()
                    delay(0.5, work: {
                        User.storeRecentUserName("")
                        if !currentDevice.isPad {
                            UIDevice.currentDevice().setValue(NSNumber.init(long: UIDeviceOrientation.Portrait.rawValue), forKey: "orientation")
                        }
                        print("oritentation is portrait: \(self.interfaceOrientation.isPortrait)")
                        print("width: \(CURRENT_SCREEN_WIDTH) - height: \(CURRENT_SCREEN_HEIGHT)")
                        WISCommon.currentAppDelegate.window?.rootViewController = LoginViewController()
                        SVProgressHUD.dismiss()
                    })
                    
                    }, cancelAction: { () -> Void in
                })
                
            default:
                return
            }
            
        default:
            return
        }
    } 
}
