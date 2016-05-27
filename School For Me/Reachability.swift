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

public class Reachability {
    
    // NOTE: - Class is mainly used to check if the user has a sufficient network connection. If not, we can ignore trying to initiate network calls.
    
    class func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(&zeroAddress) {
            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
    
    class func displayNoConnectionAlert(viewController: UIViewController) {
        let noConnectionAlert = UIAlertController(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", preferredStyle: .Alert)
        noConnectionAlert.addAction(UIAlertAction(title: "Dismiss", style: .Default, handler: nil))
        viewController.presentViewController(noConnectionAlert, animated: true, completion: nil)
    }
}
