//
//  LeftMenuTableViewController.swift
//  WISData.JunZheng
//
//  Created by Allen on 16/8/24.
//  Copyright © 2016 Wisdri. All rights reserved.
//

import UIKit
import FXBlurView

class LeftMenuViewController: UIViewController {
    
    var selectedMenuItem : Int = 0
    
    private let leftMenuCellID = "LeftMenuCell"
    
    var backgroundImageView: UIImageView?
    var frostedView = FXBlurView()
    
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
        self.backgroundImageView = UIImageView()
        self.backgroundImageView!.frame = self.view.frame
        self.backgroundImageView!.contentMode = .ScaleToFill
        view.addSubview(self.backgroundImageView!)
        
        frostedView.underlyingView = self.backgroundImageView!
        frostedView.dynamic = false
        frostedView.tintColor = UIColor.clearColor()
        frostedView.frame = self.view.frame
        self.view.addSubview(frostedView)
        
        self.view.addSubview(self.tableView);
        self.tableView.snp_makeConstraints{ (make) -> Void in
            make.right.bottom.left.equalTo(self.view)
            make.top.equalTo(self.view).offset(15)
        }
        
        // Preserve selection between presentations
//        self.clearsSelectionOnViewWillAppear = false
        
//        tableView.selectRowAtIndexPath(NSIndexPath(forRow: selectedMenuItem, inSection: 0), animated: false, scrollPosition: .Middle)
        
        

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
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return [1, 4, 2][section]
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = getCell(tableView, cell: LeftUserHeadCell.self, indexPath: indexPath)
            
            cell.avatarImageView.image = UIImage(named: "default_avatar_60")
            cell.userNameLabel.text = "admin"
            
            return cell
        
        case 1:
            
            let cell = getCell(tableView, cell: LeftMenuCell.self, indexPath: indexPath)
            
            cell.annotationLabel.text = "\(indexPath.row + 1)#炉"
            cell.menuIconImageView.image = UIImage.imageUsedTemplateMode("icon_house")
        
            return cell
            
        case 2:
            
            let cell = getCell(tableView, cell: LeftMenuCell.self, indexPath: indexPath)
            cell.annotationLabel.text = ["关于", "退出"][indexPath.row]
            let names = ["icon_about", "icon_logout"]
            cell.menuIconImageView.image = UIImage.imageUsedTemplateMode(names[indexPath.row])
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
        
        if indexPath.section == 1 {
            
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
        }
    }
    

}
