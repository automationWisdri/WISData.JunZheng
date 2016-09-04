//
//  DailyMaterialPowerCell.swift
//  WISData.JunZheng
//
//  Created by Allen on 16/9/1.
//  Copyright © 2016 Wisdri. All rights reserved.
//

import UIKit

class DailyMaterialPowerCell: UITableViewCell {

    @IBOutlet weak var firstTitleLabel: UILabel!
    @IBOutlet weak var firstContentLabel: UILabel!
    @IBOutlet weak var secondTitleLabel: UILabel!
    @IBOutlet weak var secondContentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        firstTitleLabel.backgroundColor = UIColor.wisGroupHeaderColor()
        secondTitleLabel.backgroundColor = UIColor.wisGroupHeaderColor()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
