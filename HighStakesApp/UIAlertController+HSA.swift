//
//  HSAAlertController.swift
//  HighStakesApp
//
//  Created by Walter Fernandes de Carvalho on 21/12/16.
//  Copyright © 2016 Walter Fernandes de Carvalho. All rights reserved.
//

import UIKit

extension UIAlertController {
    
    class func present(viewController:UIViewController!, title: String?, message: String?, dissmisTitle: String?) {

        present(viewController: viewController, title: title, message: message, dissmisTitle: dissmisTitle, dissmisHandler: nil)
    }

    class func present(viewController:UIViewController!, title: String?, message: String?, dissmisTitle: String?, dissmisHandler: (() -> Swift.Void)? = nil) {
        
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: dissmisTitle, style: .default, handler: { (alertAction) in
            alert.dismiss(animated: true, completion: nil)
            if dissmisHandler != nil {
                dissmisHandler!()
            }
        }))
        
        viewController.present(alert, animated: true, completion: nil)
    }

}

