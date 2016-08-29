//
//  DataTableCell.swift
//  WISData.JunZheng
//
//  Created by 任韬 on 16/8/29.
//  Copyright © 2016年 Wisdri. All rights reserved.
//

import UIKit

class DataTableCell: UITableViewCell {

    @IBOutlet weak var dataTextView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        alignTextVerticalInTextView(self.dataTextView)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
