//
//  MaterialPowerViewController.swift
//  WISData.JunZheng
//
//  Created by Allen on 16/8/24.
//  Copyright © 2016 Wisdri. All rights reserved.
//

import UIKit
import SwiftyJSON

class MaterialPowerViewController: UIViewController {
    
    @IBOutlet weak var dataTextView: UITextView!
    
    class func instantiateFromStoryboard() -> MaterialPowerViewController {
        let storyboard = UIStoryboard(name: "MaterialPower", bundle: nil)
        return storyboard.instantiateViewControllerWithIdentifier(String(self)) as! MaterialPowerViewController
    }

    private var dailyMaterialPowerView: DailyMaterialPowerView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.dailyMaterialPowerView == nil {
            self.dailyMaterialPowerView = (NSBundle.mainBundle().loadNibNamed("DailyMaterialPowerView", owner: self, options: nil).last as! DailyMaterialPowerView
            )
        }
        self.dailyMaterialPowerView!.frame = CGRectMake(0.0, 0.0, CURRENT_SCREEN_WIDTH, 185)
        
        self.view.addSubview(dailyMaterialPowerView!)
        
        
        
//        MaterialPower.get(date: "2016/8/15", shiftNo: "1", lNo: "1") { (response: WISValueResponse<String>) in
//            if response.success {
////                SVProgressHUD.showSuccessWithStatus("登录成功")
//                
//                self.dataTextView.text = response.value
//            } else {
//                wisError(response.message)
//            }
//        }
        
        
//        Operation.get(date: "2016/8/31", shiftNo: "1", lNo: "2") { (response: WISValueResponse<String>) in
//            if response.success {
//                self.dataTextView.text = response.value
//            } else {
//                wisError(response.message)
//            }
//        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
