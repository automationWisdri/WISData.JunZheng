//
//  NoDataView.swift
//  WISData.JunZheng
//
//  Created by Jingwei Wu on 9/6/16.
//  Copyright © 2016 Wisdri. All rights reserved.
//

import UIKit

class NoDataView: UIView {
    @IBOutlet weak var hintLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.hintLabel.textColor = UIColor.darkGrayColor()
        self.hintLabel.text = "数据获取失败！请检查网络连接与查询设置"
        // self.backgroundColor = UIColor.lightTextColor()
    }
}
