//
//  DataTableCell.swift
//  WISData.JunZheng
//
//  Created by Allen on 16/8/29.
//  Copyright © 2016 Wisdri. All rights reserved.
//

import UIKit

class DataTableCell: UITableViewCell {

    @IBOutlet weak var dataTextView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        alignTextVerticalInTextView(self.dataTextView)
        dataTextView.userInteractionEnabled = false
        self.userInteractionEnabled = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
