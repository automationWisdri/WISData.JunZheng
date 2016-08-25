//
//  BoilerPurifyViewController.swift
//  WISData.JunZheng
//
//  Created by 任韬 on 16/8/24.
//  Copyright © 2016年 Wisdri. All rights reserved.
//

import UIKit

class BoilerPurifyViewController: UIViewController {

    @IBOutlet weak var dataTextView: UITextView!
    
    class func instantiateFromStoryboard() -> BoilerPurifyViewController {
        let storyboard = UIStoryboard(name: "BoilerPurify", bundle: nil)
        return storyboard.instantiateViewControllerWithIdentifier(String(self)) as! BoilerPurifyViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        BoilerPurify.get(date: "2016/8/17", shiftNo: "1", lNo: "1") { (response: WISValueResponse<String>) in
            if response.success {
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
