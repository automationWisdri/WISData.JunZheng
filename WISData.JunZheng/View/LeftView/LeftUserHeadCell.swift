//
//  LeftUserHeadCell.swift
//  V2ex-Swift
//
//  Created by huangfeng on 1/23/16.
//  Copyright © 2016 Fin. All rights reserved.
//

import UIKit

class LeftUserHeadCell: UITableViewCell {
    /// 头像
    var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor(white: 0.9, alpha: 0.3)
        imageView.layer.borderWidth = 1.5
        imageView.layer.borderColor = UIColor(white: 1, alpha: 0.6).CGColor
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 25
        return imageView
    }()
    /// 用户名
    var userNameLabel: UILabel = {
        let label = UILabel()
        label.font = wisFont(15)
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setup() -> Void {
        
        self.backgroundColor = UIColor.clearColor()
        self.selectionStyle = .None

        self.contentView.addSubview(self.avatarImageView)
        self.contentView.addSubview(self.userNameLabel)
        
        self.avatarImageView.snp_makeConstraints{ (make) -> Void in
//            make.centerX.equalTo(self.contentView)
//            make.centerY.equalTo(self.contentView).offset(-8)
//            make.width.height.equalTo(self.avatarImageView.layer.cornerRadius * 2)
            make.left.equalTo(self.contentView).offset(10)
            make.top.equalTo(self.contentView).offset(20)
            make.width.height.equalTo(self.avatarImageView.layer.cornerRadius * 2)
        }
        
        self.userNameLabel.snp_makeConstraints{ (make) -> Void in
//            make.top.equalTo(self.avatarImageView.snp_bottom).offset(10)
//            make.centerX.equalTo(self.avatarImageView)
            make.left.equalTo(self.avatarImageView.snp_right).offset(10)
            make.centerY.equalTo(self.avatarImageView)
        }

        self.userNameLabel.textColor = UIColor.lightTextColor()

    }

}
