//
//  WISAlert.swift
//  WISData.JunZheng
//
//  Created by Allen on 5/17/16.
//  Copyright © 2016 Wisdri. All rights reserved.
//

import UIKit

class WISAlert {

    class func confirmOrCancel(title title: String, message: String, confirmTitle: String, cancelTitle: String, inViewController viewController: UIViewController?, withConfirmAction confirmAction: () -> Void, cancelAction: () -> Void) {

        dispatch_async(dispatch_get_main_queue()) {

            let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)

            let cancelAction: UIAlertAction = UIAlertAction(title: cancelTitle, style: .Cancel) { action -> Void in
                cancelAction()
            }
            alertController.addAction(cancelAction)

            let confirmAction: UIAlertAction = UIAlertAction(title: confirmTitle, style: .Default) { action -> Void in
                confirmAction()
            }
            alertController.addAction(confirmAction)

            viewController?.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    
}
