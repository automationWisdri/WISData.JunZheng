//
//  NoDataView.swift
//  WISData.JunZheng
//
//  Created by Jingwei Wu on 9/6/16.
//  Copyright © 2016 Wisdri. All rights reserved.
//

import UIKit

class NoDataView: UIView {
    @IBOutlet weak var hintTextView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.hintTextView.textColor = UIColor.darkGrayColor()
        self.hintTextView.text = "数据获取失败\n请检查网络连接与查询设置"
        self.hintTextView.userInteractionEnabled = false
        self.hintTextView.scrollsToTop = false
        // self.backgroundColor = UIColor.lightTextColor()
    }
}
