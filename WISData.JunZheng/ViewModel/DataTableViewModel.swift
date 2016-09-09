//
//  FurnaceViewModel.swift
//  WISData.JunZheng
//
//  Created by Jingwei Wu on 9/2/16.
//  Copyright © 2016 Wisdri. All rights reserved.
//

import UIKit

#if !RX_NO_MODULE
    import RxDataSources
    import RxSwift
    import RxCocoa
#endif

class DataTableViewModel: ViewModel {
    weak var tableView: DataTableView!
    
    var headerString: String = EMPTY_STRING
    var titleArray: [String] = []
    
    var headerStringSubject: BehaviorSubject<String> = BehaviorSubject(value: EMPTY_STRING)
    var titleArraySubject: BehaviorSubject<[String]> = BehaviorSubject(value: [])
    
    let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, String>>()
    
    init(sourceTableView: DataTableView) {
        super.init()
        
        tableView = sourceTableView
        
        // use local variable to avoid reference cycle.
        let dataSource = self.dataSource        
        
        let tableViewItems = Observable.combineLatest(headerStringSubject, titleArraySubject) {headerString, titleArray in
            return [SectionModel(model: headerString, items: titleArray)]
        }
        
        tableViewItems
            .subscribeOn(MainScheduler.instance)
            .bindTo(tableView.rx_itemsWithDataSource(dataSource))
            .addDisposableTo(disposeBag)
    }
}
