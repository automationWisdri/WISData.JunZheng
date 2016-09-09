//
//  DataDetailCell.swift
//  WISData.JunZheng
//
//  Created by Jingwei Wu on 9/7/16.
//  Copyright © 2016 Wisdri. All rights reserved.
//

import UIKit

class DataDetailCell: UICollectionViewCell {
    /* @IBOutlet */ weak var dataTitleTextView: UITextView! = UITextView()
    /* @IBOutlet */ weak var dataTextView: UITextView!  = UITextView()
    /* @IBOutlet */ weak var verticalLineView: HorizontalLineView! = HorizontalLineView.init(frame: CGRectZero)
    /* @IBOutlet */ weak var horizontalLineView: HorizontalLineView! = HorizontalLineView.init(frame: CGRectZero)
    
    static let DataDetailCellID = "DataDetailCell"
    static let DataDetailCollectionViewSectionInset = CGFloat(10.0)
    static let DataDetailCollectionViewSpacingForCell = CGFloat(3.0)
    static let DataDetailCollectionViewSpacingForLine = CGFloat(3.0)
    
    static var DataDetailCellContentSize: CGSize {
        let verticalWidth = min(CURRENT_SCREEN_WIDTH, CURRENT_SCREEN_HEIGHT)
        
        let width = verticalWidth - DataDetailCell.DataDetailCollectionViewSpacingForCell - (2 * DataDetailCell.DataDetailCollectionViewSectionInset)
        
        return CGSize(width: width / 2, height: CGFloat(60.0))
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        self.arrangeCellSubView()
        
        dataTitleTextView.backgroundColor = UIColor.wisBackgroundColor()
        dataTitleTextView.scrollsToTop = false
        dataTitleTextView.userInteractionEnabled = false
        
        verticalLineView.backgroundColor = UIColor.clearColor()
        
        dataTextView.scrollsToTop = false
        dataTextView.userInteractionEnabled = false
        
        horizontalLineView.backgroundColor = UIColor.clearColor()
    }

    /*
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        dataTitleTextView.backgroundColor = UIColor.wisBackgroundColor()
        dataTitleTextView.scrollsToTop = false
        dataTitleTextView.userInteractionEnabled = false
        
        // verticalLineView = HorizontalLineView.init(frame: CGRectZero)
        // verticalLineView.backgroundColor = UIColor.clearColor()
        
        dataTextView.scrollsToTop = false
        dataTextView.userInteractionEnabled = false
        
        // horizontalLineView = HorizontalLineView.init(frame: CGRectZero)
        // horizontalLineView.backgroundColor = UIColor.clearColor()
        
        self.arrangeCellView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
     */
    
    override func layoutSubviews() {
        super.layoutSubviews()
        arrangeCellSubView()
    }
    
    func arrangeCellSubView() {
        let cellSize = DataDetailCell.DataDetailCellContentSize
//        self.frame = CGRectMake(0, 0, cellSize.width, cellSize.height)
        self.frame.size = DataDetailCell.DataDetailCellContentSize
        
        let dataTitleTextViewFrame = CGRectMake(0,
                                                0,
                                                cellSize.width * 0.55,
                                                cellSize.height - 1.0)
        dataTitleTextView.frame = dataTitleTextViewFrame
        
        let verticalLineViewFrame = CGRectMake(dataTitleTextViewFrame.width ,
                                               0,
                                               CGFloat(1.0),
                                               cellSize.height - 1.0)
        verticalLineView.frame = verticalLineViewFrame
        
        let dataTextViewFrame = CGRectMake(dataTitleTextViewFrame.width + verticalLineViewFrame.width,
                                           0,
                                           cellSize.width - dataTitleTextViewFrame.width - verticalLineViewFrame.width,
                                           cellSize.height - 1.0)
        dataTextView.frame = dataTextViewFrame
        
        let horizontalLineViewFrame = CGRectMake(0, dataTitleTextViewFrame.height, cellSize.width, CGFloat(1.0))
        horizontalLineView.frame = horizontalLineViewFrame
    }
    
    func fillData(content: (title: String, data: String)) {
        self.dataTitleTextView.text = content.title
        self.dataTextView.text = content.data != "" ? content.data : "--"
    }
}
