//
//  FurnaceViewController.swift
//  WISData.JunZheng
//
//  Created by 任韬 on 16/8/24.
//  Copyright © 2016年 Wisdri. All rights reserved.
//

import UIKit

public let DataSearchNotification = "DataSearchNotification"

class FurnaceViewController: UIViewController {

    @IBOutlet weak var searchParameterLabel: UILabel!
    @IBOutlet weak var dataTextView: UITextView!
    
    class func instantiateFromStoryboard() -> FurnaceViewController {
        let storyboard = UIStoryboard(name: "Furnace", bundle: nil)
        return storyboard.instantiateViewControllerWithIdentifier(String(self)) as! FurnaceViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // observing notifications
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.handleNotification(_:)), name: DataSearchNotification, object: nil)
        
        getData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getData() {
        
        Furnace.get(date: SearchParameter["date"]!, shiftNo: SearchParameter["shiftNo"]!, lNo: SearchParameter["lNo"]!) { (response: WISValueResponse<String>) in
            if response.success {
                self.searchParameterLabel.text = "查询参数：" + SearchParameter["date"]! + " | " + getShiftName(SearchParameter["shiftNo"]!) + " | " + SearchParameter["lNo"]! + "#炉"
                self.dataTextView.text = response.value
            } else {
                wisError(response.message)
            }
        }
    }
    
    func handleNotification(notification: NSNotification) -> Void {
        getData()
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
