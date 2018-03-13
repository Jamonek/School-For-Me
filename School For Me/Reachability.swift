//
//  Reachability.swift
//  School For Me
//
//  Created by Jamone Alexander Kelly on 3/17/16.
//  Copyright © 2016 Jamone Kelly. All rights reserved.
//

import Foundation
import SystemConfiguration
import UIKit

open class Reachability {
    
    // NOTE: - Class is mainly used to check if the user has a sufficient network connection. If not, we can ignore trying to initiate network calls.
    
    class func isConnectedToNetwork() -> Bool {
        return true
    }
    
    class func displayNoConnectionAlert(_ viewController: UIViewController) {
        let noConnectionAlert = UIAlertController(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", preferredStyle: .alert)
        noConnectionAlert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        viewController.present(noConnectionAlert, animated: true, completion: nil)
    }
}
