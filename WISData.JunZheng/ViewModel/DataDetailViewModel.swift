//
//  DataDetailViewModel.swift
//  WISData.JunZheng
//
//  Created by Jingwei Wu on 9/7/16.
//  Copyright © 2016 Wisdri. All rights reserved.
//

import UIKit
#if !RX_NO_MODULE
    import RxDataSources
    import RxSwift
    import RxCocoa
#endif

class DataDetailViewModel: ViewModel {
    weak var collectionView: UICollectionView?
    
    var viewTitle: String = EMPTY_STRING
    var dataDetailContents: [String: String] = [:]
    
    var viewTitleSubject: BehaviorSubject<String> = BehaviorSubject(value: EMPTY_STRING)
    var dataDetailContentsSubject: BehaviorSubject<[(String, String)]> = BehaviorSubject(value: [(EMPTY_STRING,EMPTY_STRING)])
    
    let dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, (String, String)>>()
    
    override init() {
        super.init()
    }
    
    func setDataSource(sourceCollectionView: UICollectionView) {
        // use local variable to avoid reference cycle.
        collectionView = sourceCollectionView
        let dataSource = self.dataSource
        
        let collectionViewItems = Observable.combineLatest(viewTitleSubject, dataDetailContentsSubject) {title, contents in
            return [SectionModel(model: title, items: contents)]
        }
        
        collectionViewItems
            .subscribeOn(MainScheduler.instance)
            .bindTo(collectionView!.rx_itemsWithDataSource(dataSource))
            .addDisposableTo(disposeBag)
    }
}
