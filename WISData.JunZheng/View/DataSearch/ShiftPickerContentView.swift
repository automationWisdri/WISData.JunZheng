//
//  ShiftPickerContentView.swift
//  WISData.JunZheng
//
//  Created by Jingwei Wu on 6/1/16.
//  Copyright © 2016 Wisdri. All rights reserved.
//

import UIKit

class ShiftPickerContentView: UIView {
    
    private let shiftSelectionCellID = "shiftSelectionCell"
    
    private let cellHeight: CGFloat = 40
    private let headerHeight: CGFloat = 35
    private let viewHeightOffset: CGFloat = 0
    
    var viewHeight: CGFloat {
        return CGFloat(ShiftType.count) * cellHeight + viewHeightOffset + headerHeight
    }

    @IBOutlet weak var shiftSelectionTableView: UITableView!
    
    var currentSelectedIndexPath = NSIndexPath(forRow: 0, inSection: 0) {
        didSet {
            if currentSelectedIndexPath.row != oldValue.row {
                let newSelectedCell = self.shiftSelectionTableView.cellForRowAtIndexPath(currentSelectedIndexPath)
                let oldSelectedCell = self.shiftSelectionTableView.cellForRowAtIndexPath(oldValue)
                
                newSelectedCell?.accessoryType = .Checkmark
                oldSelectedCell?.accessoryType = .None
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        shiftSelectionTableView.dataSource = self
        shiftSelectionTableView.delegate = self
        
        shiftSelectionTableView.separatorColor = UIColor.wisCellSeparatorColor()
        shiftSelectionTableView.setEditing(false, animated: true)
        shiftSelectionTableView.scrollsToTop = false
        
        shiftSelectionTableView.tableHeaderView?.tintColor = UIColor.wisTintColor()
    }
    
    func bindData(initialShiftType: ShiftType) {
        self.currentSelectedIndexPath = NSIndexPath(forRow: initialShiftType.rawValue, inSection: 0)
    }
}


// MARK: - UITableViewDataSource, UITableViewDelegate

extension ShiftPickerContentView: UITableViewDataSource, UITableViewDelegate {
    
    /// Number of sections in TableView
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    /// Number of Rows in each section
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ShiftType.count
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
            return cellHeight
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "选择班别"
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return headerHeight
    }
    
    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = UIColor.groupTableViewBackgroundColor()
        let headerView = view as! UITableViewHeaderFooterView
        headerView.textLabel?.font = UIFont.systemFontOfSize(16)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        guard let shiftType = ShiftType(rawValue: indexPath.row) else {
            return UITableViewCell()
        }
        
        let cell = UITableViewCell(style: .Value1, reuseIdentifier: self.shiftSelectionCellID)
        cell.textLabel!.text = shiftType.stringOfType
        cell.textLabel!.font = UIFont.systemFontOfSize(15)
        cell.indentationLevel = 1
        cell.selectionStyle = .Default
        
        if indexPath.row == currentSelectedIndexPath.row {
            cell.accessoryType = .Checkmark
        } else {
            cell.accessoryType = .None
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        guard indexPath.row != currentSelectedIndexPath.row else {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            return
        }
        
        let newSelectedCell = tableView.cellForRowAtIndexPath(indexPath)
        let oldSelectedCell = tableView.cellForRowAtIndexPath(currentSelectedIndexPath)
        
        newSelectedCell?.accessoryType = .Checkmark
        oldSelectedCell?.accessoryType = .None
        
        currentSelectedIndexPath = indexPath
        
        defer {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
    }
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return .None
    }
}
