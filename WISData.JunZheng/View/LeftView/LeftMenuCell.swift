//
//  LeftMenuCell.swift
//  WISData.JunZheng
//
//  Created by Allen on 4/27/16.
//  Copyright © 2016 Wisdri. All rights reserved.
//

import UIKit

class LeftMenuCell: UITableViewCell {

    @IBOutlet weak var annotationLabel: UILabel!
    @IBOutlet weak var menuIconImageView: UIImageView!
    @IBOutlet weak var accessoryImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()

        self.backgroundColor = UIColor.clearColor()
        menuIconImageView.tintColor = UIColor(white: 1, alpha: 0.6)
        
        annotationLabel.textColor = UIColor(white: 1, alpha: 0.6)
        annotationLabel.highlightedTextColor = UIColor.whiteColor()
        
        accessoryImageView.image = UIImage.imageUsedTemplateMode("icon_angle_right")
        accessoryImageView.tintColor = UIColor(white: 1, alpha: 0.6)
        
        let selectedBackgroundView = UIView(frame: CGRectMake(0, 0, self.frame.size.width, self.frame.size.height))
        selectedBackgroundView.backgroundColor = UIColor(white: 0.1, alpha: 0.3)
        self.selectedBackgroundView = selectedBackgroundView
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
