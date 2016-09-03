//
//  DataTableView.swift
//  WISData.JunZheng
//
//  Created by Allen on 16/8/23.
//  Copyright © 2016 Wisdri. All rights reserved.
//

import UIKit

public let DataTableHeaderRowHeight: CGFloat = 60.0
public let DataTableRowHeight: CGFloat = 30.0

protocol DataTableViewDelegate {
    func dataTableViewContentOffSet(contentOffSet: CGPoint)
}

class DataTableView: UITableView {

    var dataTableDelegate: DataTableViewDelegate!
    // var titleArray: [String] = []
    // var headerString: String = EMPTY_STRING
    
    var viewModel: DataTableViewModel!
    
    private let DataTableCellID = "DataTableCell"
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style:style)
        
        self.viewModel = DataTableViewModel(sourceTableView: self)
        setupViews()
        self.registerNib(UINib(nibName: DataTableCellID, bundle: nil), forCellReuseIdentifier: DataTableCellID)
        
        // bind data
        self.rx_setDelegate(self)
            .addDisposableTo(viewModel.disposeBag)
        
        self.viewModel.dataSource
            .configureCell = { [unowned self] (_, tableView, indexPath, element) in
            let cell = getCell(tableView, cell: DataTableCell.self, indexPath: indexPath)
            cell.dataTextView.text = self.viewModel.titleArray[indexPath.row]
            return cell
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        // self.delegate = self
        // self.dataSource = self
        self.showsVerticalScrollIndicator = false
        self.backgroundColor = UIColor.clearColor()
        self.separatorStyle = .None
        self.bounces = false
        self.rowHeight = DataTableRowHeight
    }
    
    func setTableViewContentOffSet(contentOffset:CGPoint) {
        self.setContentOffset(contentOffset, animated: false)
    }
}

// MARK: - UITableView Delegate & DataSource

extension DataTableView: UITableViewDelegate {
    /*
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = getCell(tableView, cell: DataTableCell.self, indexPath: indexPath)
        cell.dataTextView.text = titleArray[indexPath.row]

        return cell
    }
    */
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UITableViewHeaderFooterView(frame: CGRectMake (0, 0, self.frame.width, DataTableHeaderRowHeight))
        headerView.contentView.backgroundColor = UIColor.wisGroupHeaderColor()

        let headerTextView = UITextView(frame: CGRect(x: 0, y: 0, width: headerView.bounds.width, height: headerView.bounds.height - 1))
        headerTextView.text = self.viewModel.headerString
        headerTextView.textColor = UIColor.blackColor()
        headerTextView.font = wisFont(12)
        headerTextView.backgroundColor = UIColor.clearColor()
        headerTextView.textAlignment = .Center
        //
        // Text vertical center align is not stable, TBC.
        //
        alignTextVerticalInTextView(headerTextView)
        headerTextView.userInteractionEnabled = false
        headerView.addSubview(headerTextView)
        
        let bottomLineView = HorizontalLineView(frame: CGRect(x: 0, y: headerView.bounds.height - 1, width: headerView.bounds.width, height: 1))
        headerView.addSubview(bottomLineView)
        
        return headerView
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return DataTableHeaderRowHeight
    }
}

// MARK: - UIScrollView delegate
extension DataTableView: UIScrollViewDelegate {
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        dataTableDelegate?.dataTableViewContentOffSet(scrollView.contentOffset)
    }
}

