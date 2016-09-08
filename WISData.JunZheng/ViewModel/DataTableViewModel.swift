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
    
    var titleArray: [String] = []
    var headerString: String = EMPTY_STRING
    
    var titleArraySubject: BehaviorSubject<[String]> = BehaviorSubject(value: [])
    var headerStringSubject: BehaviorSubject<String> = BehaviorSubject(value: EMPTY_STRING)
    
    let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, String>>()
    
    init(sourceTableView: DataTableView) {
        super.init()
        
        tableView = sourceTableView
        
        // use local variable to avoid reference cycle.
        let dataSource = self.dataSource        
        
        let tableViewItems = Observable.combineLatest(titleArraySubject, headerStringSubject) {titleArray, headerString in
            return [SectionModel(model: headerString, items: titleArray)]
        }
        
        tableViewItems
            .subscribeOn(MainScheduler.instance)
            .bindTo(tableView.rx_itemsWithDataSource(dataSource))
            .addDisposableTo(disposeBag)
        

    }
}
