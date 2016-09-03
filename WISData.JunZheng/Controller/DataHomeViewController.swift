//
//  HomeViewController.swift
//  WISData.JunZheng
//
//  Created by Allen on 16/8/22.
//  Copyright © 2016 Wisdri. All rights reserved.
//

import UIKit
import PagingMenuController
import LMDropdownView
import SVProgressHUD
import DrawerController

public let DataSearchNotification = "DataSearchNotification"

// MARK: - Paging Menu Configuration
private var pagingControllers: [UIViewController] {
    let furnaceViewController = FurnaceViewController.instantiateFromStoryboard()
    let boilerPurifyPowerViewController = BoilerPurifyViewController.instantiateFromStoryboard()
    let materialPowerViewController = MaterialPowerViewController.instantiateFromStoryboard()
    return [furnaceViewController, boilerPurifyPowerViewController, materialPowerViewController]
}

struct FurnaceMenuItem: MenuItemViewCustomizable {}
struct BoilerPurifyMenuItem: MenuItemViewCustomizable {}
struct MaterialPowerItem: MenuItemViewCustomizable {}

private let font = UIFont.systemFontOfSize(15)
private let selectedFont = UIFont.boldSystemFontOfSize(16)
private let color = UIColor.wisGrayColor()
private let selectedColor = UIColor.wisLogoColor()

struct PagingMenuOptions: PagingMenuControllerCustomizable {
    
    var componentType: ComponentType {
        return .All(menuOptions: MenuOptions(), pagingControllers: pagingControllers)
    }
    
    var scrollEnabled: Bool {
        return false
    }
    
    struct MenuOptions: MenuViewCustomizable {
        
        var displayMode: MenuDisplayMode {
            return .SegmentedControl
        }
        var focusMode: MenuFocusMode {
            return .Underline(height: 1.5, color: UIColor.wisLogoColor(), horizontalPadding: 1.5, verticalPadding: 1.5)
        }
        var height: CGFloat {
            return 35
        }
        var itemsOptions: [MenuItemViewCustomizable] {
            return [FurnaceMenuItem(), BoilerPurifyMenuItem(), MaterialPowerMenuItem()]
        }
    }
    
    struct FurnaceMenuItem: MenuItemViewCustomizable {
        
        let menuTitle = "电石炉"
        
        var displayMode: MenuItemDisplayMode {
            let title = MenuItemText(text: menuTitle, color: color, selectedColor: selectedColor, font: font, selectedFont: selectedFont)
            return .Text(title: title)
        }
    }
    
    struct BoilerPurifyMenuItem: MenuItemViewCustomizable {
        
        let menuTitle = "锅炉及净化"
        
        var displayMode: MenuItemDisplayMode {
            let title = MenuItemText(text: menuTitle, color: color, selectedColor: selectedColor, font: font, selectedFont: selectedFont)
            return .Text(title: title)
        }
    }
    
    struct MaterialPowerMenuItem: MenuItemViewCustomizable {
        
        let menuTitle = "原料消耗"
        
        var displayMode: MenuItemDisplayMode {
            let title = MenuItemText(text: menuTitle, color: color, selectedColor: selectedColor, font: font, selectedFont: selectedFont)
            return .Text(title: title)
        }
    }
}

enum ShiftType: Int {

    case MorningShift = 0
    case MiddleShift = 1
    case NightShift = 2
    
    static let count: Int = {
        return 3
    }()
    
    var stringOfType: String {
        switch self {
        case .MorningShift:
            return "早班"
        case .MiddleShift:
            return "中班"
        case .NightShift:
            return "晚班"
        }
    }
    
    var getShiftNoForSearch: String {
        switch self {
        case .MorningShift:
            return "2"
        case .MiddleShift:
            return "3"
        case .NightShift:
            return "1"
        }
    }
}

// MARK: - DataHomeViewController

class DataHomeViewController: UIViewController {
    
    var baseTitle = "电石炉生产数据"
    
    // for drop down search view
    var searchDropDownView: LMDropdownView = LMDropdownView()
    var searchContentView: DataSearchContentView?
    
//    @IBAction func popSearchPanelAction(sender: UIBarButtonItem) {
//        showDropDownViewFromDirection(.Top)
//    }
//    
//    @IBAction func toggleSideMenu(sender: UIBarButtonItem) {
//        
//    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Layout Setup
        self.navigationItem.title = SearchParameter["lNo"]! + "#" + baseTitle
        
        let navigationBackButton = UIBarButtonItem()
        navigationBackButton.title = EMPTY_STRING
        self.navigationItem.backBarButtonItem = navigationBackButton
        
        let leftBarItem = UIBarButtonItem.init(image: UIImage(named: "icon_menu")!, style: .Plain, target: self, action: #selector(self.toggleLeftDrawer(_:)))
        self.navigationItem.leftBarButtonItem = leftBarItem
        
        let rightBarItem = UIBarButtonItem.init(barButtonSystemItem: .Search, target: self, action: #selector(self.dropDownDataSearchContent(_:)))
        self.navigationItem.rightBarButtonItem = rightBarItem
        
        // Call Paging Menu
        let pagingMenuController = PagingMenuController(options: PagingMenuOptions())
        pagingMenuController.delegate = self
        
        arrangePagingMenuView(pagingMenuController)
        
        addChildViewController(pagingMenuController)
        view.addSubview(pagingMenuController.view)
        pagingMenuController.didMoveToParentViewController(self)
        
        // Call Filter View
        
        self.searchContentView = DataSearchContentView(frame: CGRectMake(0.0, 0.0, CGRectGetWidth(self.view.bounds), min(CGRectGetHeight(self.view.bounds) - 50, 450)), parentViewController: self)
        
        self.searchDropDownView.delegate = self
        
        // Customize Dropdown Style
        self.searchDropDownView.closedScale = 1.0
        self.searchDropDownView.blurRadius = 3;
        self.searchDropDownView.blackMaskAlpha = 0.2;
        self.searchDropDownView.animationDuration = 0.45;
        self.searchDropDownView.animationBounceHeight = 0.0;
        
        self.searchDropDownView.contentBackgroundColor = UIColor.whiteColor()
        
        self.searchDropDownView.delegate = self
        self.searchContentView?.delegate = self
        
        // observing notifications
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.handleNotification(_:)), name: DataSearchNotification, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func willAnimateRotationToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        let pagingMenuController = self.childViewControllers[0] as! PagingMenuController
        arrangePagingMenuView(pagingMenuController).layoutIfNeeded()
    }
    
    private func arrangePagingMenuView(pagingMenuController: UIViewController) -> UIView {
        let navigationBarHeight = self.navigationController?.navigationBar.bounds.height
        let statusBarHeight = STATUS_BAR_HEIGHT
        
        let pageWidth = CURRENT_SCREEN_WIDTH
        let pageHeight = CURRENT_SCREEN_HEIGHT - navigationBarHeight! - statusBarHeight
        
        pagingMenuController.view.frame = CGRectMake(0, navigationBarHeight! + statusBarHeight, pageWidth, pageHeight)
        
        return pagingMenuController.view
    }
    
    func toggleLeftDrawer(sender: UIBarButtonItem) -> Void {
        WISClient.sharedInstance.drawerController?.toggleLeftDrawerSideAnimated(true, completion: nil)
    }
    
    func handleNotification(notification: NSNotification) -> Void {
        self.navigationItem.title = SearchParameter["lNo"]! + "#" + baseTitle
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

// MARK: - PagingMenuControllerDelegate

extension DataHomeViewController: PagingMenuControllerDelegate {
    
    func didMoveToPageMenuController(menuController: UIViewController, previousMenuController: UIViewController) {
//        let didAppearViewController = menuController as! MaterialPowerViewController
//        let previousViewController = previousMenuController as! TaskListViewController
        
//        didAppearViewController.taskTableView.scrollsToTop = true
//        didAppearViewController.getTaskList(didAppearViewController.taskType!, groupType: didAppearViewController.groupType, silentMode: true)
//        previousViewController.taskTableView.scrollsToTop = false
    }
    
    
}

// MARK: - Drop Down Control

extension DataHomeViewController {
    
    func dropDownDataSearchContent(sender: UIBarButtonItem) -> Void {
        showDropDownViewFromDirection(.Top)
    }
    
    func showDropDownViewFromDirection(direction: LMDropdownViewDirection) -> Void {
        self.searchDropDownView.direction = direction;
        
        if self.searchDropDownView.isOpen {
            self.searchDropDownView.hide()
        } else {
            
            switch direction {
            case .Top:
                self.searchDropDownView.showFromNavigationController(self.navigationController, withContentView: self.searchContentView)
                break
                
            default:
                break
            }
            
        }
    }
}

extension DataHomeViewController: LMDropdownViewDelegate {
    
    func dropdownViewWillShow(dropdownView: LMDropdownView!) {
        self.searchContentView?.prepareView()
    }
    
}

// MARK: - extension - Drop down data delivery

extension DataHomeViewController: DataSearchContentViewDelegate {
    
    func contentViewConfirmed() {
        print("OK Button pressed")
        
        if self.searchDropDownView.isOpen {
            self.searchDropDownView.hide()
        }
        
//        for viewController in self.viewControllers {
//            viewController.groupType = groupType
//        }
        
        let pagingMenuController = self.childViewControllers.first as! PagingMenuController
//        let currentViewController = pagingMenuController.currentViewController
        
//        currentViewController.groupTaskList(groupType)
//        currentViewController.sortTaskList()
//        currentViewController.updateTableViewInfo()
        
    }
    
    func contentViewCancelled() {
        print("Cancel Button pressed")
        if self.searchDropDownView.isOpen {
            self.searchDropDownView.hide()
        }
    }
}
