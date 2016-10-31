//
//  PopoverViewController.swift
//  WISData.JunZheng
//
//  Created by Jingwei Wu on 9/4/16.
//  Copyright © 2016 Wisdri. All rights reserved.
//

import UIKit

class SearchPopoverViewController: ViewController {

    var PopoverSuperController:UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func dismissPopoverSearchContent(animated animated: Bool = true) -> Void {
        dispatch_async(dispatch_get_main_queue()) {
            self.dismissViewControllerAnimated(animated) {
//                print("关闭查询菜单")
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
