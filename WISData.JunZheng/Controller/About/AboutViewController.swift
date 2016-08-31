//
//  AboutViewController.swift
//  WISData.JunZheng
//
//  Created by Allen on 16/8/31.
//  Copyright © 2016 Wisdri. All rights reserved.
//

import UIKit
import Ruler

class AboutViewController: UIViewController {

    @IBOutlet private weak var appLogoImageView: UIImageView!
    @IBOutlet private weak var appLogoImageViewTopConstraint: NSLayoutConstraint!
    
    @IBOutlet private weak var appNameLabel: UILabel!
    @IBOutlet private weak var appNameLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet private weak var appVersionLabel: UILabel!

    @IBOutlet weak var aboutTextView: UITextView!
    @IBOutlet weak var aboutTextViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet private weak var copyrightLabel: UILabel!

    override func viewDidLoad() {
        
        super.viewDidLoad()

        title = "关于"

        appLogoImageViewTopConstraint.constant = Ruler.iPhoneVertical(50, 70, 90, 110).value
        appNameLabelTopConstraint.constant = Ruler.iPhoneVertical(20, 30, 30, 30).value

        appNameLabel.textColor = UIColor.wisLogoColor()
        
        let infoDictionary = NSBundle.mainBundle().infoDictionary
        let versionShortString = infoDictionary!["CFBundleShortVersionString"] as! String
        let buildString = infoDictionary!["CFBundleVersion"] as! String
        
        var app_version = "Version: " + versionShortString + " (Build: " + buildString + ")"
        
        #if DEBUG
            app_version += " - " + "Debug"
        #endif
        
        self.appVersionLabel.text = app_version
    }

}


