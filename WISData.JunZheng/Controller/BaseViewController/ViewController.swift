//
//  ViewController.swift
//  WISData.JunZheng
//
//  Created by Jingwei Wu on 8/16/16.
//  Copyright © 2016 wisdri. All rights reserved.
//

import UIKit
import RxSwift

class ViewController: UIViewController {
#if TRACE_RESOURCES
    #if !RX_NO_MODULE
    private let startResourceCount = RxSwift.resourceCount
    #else
    private let startResourceCount = resourceCount
    #endif
#endif
    
    // Always dispose here
    var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
#if TRACE_RESOURCES
        print("Number of start resources = \(resourceCount)")
#endif
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    deinit {
#if TRACE_RESOURCES
        print("View controller disposed with \(resourceCount) resources")

        let numberOfResourcesThatShouldRemain = startResourceCount
        let mainQueue = dispatch_get_main_queue()

        dispatch_async(mainQueue) {
            /*
            Some small additional period to clean things up. In case there were async operations fired,
            they can't be cleaned up momentarily.
            */
            let time = dispatch_time(DISPATCH_TIME_NOW, Int64(0.2 * Double(NSEC_PER_SEC)))
            dispatch_after(time, mainQueue) {
                assert(resourceCount <= numberOfResourcesThatShouldRemain, "Resources weren't cleaned properly")
            }
        }
#endif
    }
}