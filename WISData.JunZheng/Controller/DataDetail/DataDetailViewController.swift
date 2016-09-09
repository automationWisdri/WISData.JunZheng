//
//  DataDetailViewController.swift
//  WISData.JunZheng
//
//  Created by Jingwei Wu on 9/7/16.
//  Copyright © 2016 Wisdri. All rights reserved.
//

import UIKit

#if !RX_NO_MODULE
    import RxSwift
    import RxCocoa
#endif

class DataDetailViewController: ViewController, UICollectionViewDelegate {
    @IBOutlet weak var dataDetailCollectionView: UICollectionView!
    
    var superViewController: UIViewController? = nil
    
    var viewModel: DataDetailViewModel = DataDetailViewModel()
    
    private class func instantiateFromStoryboard() -> DataDetailViewController {
        let storyboard = UIStoryboard(name: "DataDetail", bundle: nil)
        return storyboard.instantiateViewControllerWithIdentifier(String(self)) as! DataDetailViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewModel.setDataSource(self.dataDetailCollectionView)
        
        dataDetailCollectionView.allowsSelection = false
        dataDetailCollectionView.allowsMultipleSelection = false
        dataDetailCollectionView.scrollsToTop = true
        
        dataDetailCollectionView.backgroundColor = UIColor.whiteColor()
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = DataDetailCell.DataDetailCellContentSize
        layout.minimumLineSpacing = DataDetailCell.DataDetailCollectionViewSpacingForLine
        layout.minimumInteritemSpacing = DataDetailCell.DataDetailCollectionViewSpacingForCell
        layout.scrollDirection = .Vertical
        
        layout.sectionInset = UIEdgeInsets(top: DataDetailCell.DataDetailCollectionViewSectionInset,
                                           left: DataDetailCell.DataDetailCollectionViewSectionInset,
                                           bottom: DataDetailCell.DataDetailCollectionViewSectionInset,
                                           right: DataDetailCell.DataDetailCollectionViewSectionInset)

        dataDetailCollectionView.collectionViewLayout = layout
        dataDetailCollectionView.delegate = self
        
        dataDetailCollectionView.registerNib(UINib(nibName: DataDetailCell.DataDetailCellID, bundle: nil), forCellWithReuseIdentifier: DataDetailCell.DataDetailCellID)
        
        self.viewModel.viewTitleSubject.asObservable()
        .subscribeNext { self.navigationItem.title = $0 }
        .addDisposableTo(disposeBag)
        
        // bind data
        self.viewModel.dataSource
            .configureCell = { [unowned self] (_, collectionView, indexPath, element) in
                let cell = getCollectionViewCell(collectionView, cell: DataDetailCell.self, indexPath: indexPath)
                // cell.dataTextView.text = self.viewModel.titleArray[indexPath.row]
                self.viewModel.dataDetailContentsSubject.subscribeNext { contents in
                    cell.fillData((title: contents[indexPath.row].0, data: contents[indexPath.row].1))
                    cell.layoutSubviews()
                }
                .addDisposableTo(self.viewModel.disposeBag)
                return cell
        }
        
        dataDetailCollectionView
            .rx_itemSelected
            .map { indexPath in
                return (indexPath, self.viewModel.dataSource.itemAtIndexPath(indexPath))
            }
            .subscribeNext { [unowned self] indexPath, model in
                self.dataDetailCollectionView.deselectItemAtIndexPath(indexPath, animated: true)
               
            }
            .addDisposableTo(viewModel.disposeBag)
        
//        dataDetailCollectionView
//            .rx_setDelegate(self)
//            .addDisposableTo(disposeBag)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // self.dataDetailCollectionView.reloadSections([0], animationStyle: .Automatic)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func willAnimateRotationToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        self.dataDetailCollectionView.reloadSections([0], animationStyle: .Automatic)
    }

    func initialDetailData(title title: String, dataDictionary: [String: String]) {
        self.viewModel.viewTitleSubject.onNext(title)
        
        var dataContentInArray: [(String, String)] = []
        for singleData in dataDictionary {
            dataContentInArray.append(singleData)
        }
        self.viewModel.dataDetailContentsSubject.onNext(dataContentInArray)
    }
    
    
    class func performPushToDataDetailViewController(superViewController: UIViewController,
                                                     title: String,
                                                     dataContents: [String: String],
                                                     animated: Bool) -> () {
        
        let viewController = DataDetailViewController.instantiateFromStoryboard()
        viewController.initialDetailData(title: title, dataDictionary: dataContents)
        viewController.superViewController = superViewController
        
        superViewController.navigationController?.pushViewController(viewController, animated: animated)
    }
}

extension DataDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return DataDetailCell.DataDetailCellContentSize
    }
}

