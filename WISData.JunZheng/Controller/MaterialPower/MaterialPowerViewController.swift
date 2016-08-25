//
//  MaterialPowerViewController.swift
//  WISData.JunZheng
//
//  Created by Allen on 16/8/24.
//  Copyright © 2016 Wisdri. All rights reserved.
//

import UIKit

class MaterialPowerViewController: UIViewController {
    
    @IBOutlet weak var dataTextView: UITextView!
    
    class func instantiateFromStoryboard() -> MaterialPowerViewController {
        let storyboard = UIStoryboard(name: "MaterialPower", bundle: nil)
        return storyboard.instantiateViewControllerWithIdentifier(String(self)) as! MaterialPowerViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        MaterialPower.get(date: "2016/8/15", shiftNo: "1", lNo: "1") { (response: WISValueResponse<String>) in
            if response.success {
//                SVProgressHUD.showSuccessWithStatus("登录成功")
                
                self.dataTextView.text = response.value
            } else {
                wisError(response.message)
            }
        }
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
