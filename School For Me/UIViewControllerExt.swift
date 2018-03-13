//
//  UIViewControllerExt.swift
//  School For Me
//
//  Created by Jamone Alexander Kelly on 1/9/16.
//  Copyright © 2016 Jamone Kelly. All rights reserved.
//

import UIKit

extension UIViewController {
    func showDetailTV(_ sender: AnyObject?) {
        let detailTV = self.storyboard!.instantiateViewController(withIdentifier: "detailTV") as! DetailTV
        self.navigationController!.pushViewController(detailTV, animated: true)
    }
}
