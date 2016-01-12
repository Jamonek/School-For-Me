//
//  StringExt.swift
//  School For Me
//
//  Created by Jamone Alexander Kelly on 1/7/16.
//  Copyright © 2016 Jamone Kelly. All rights reserved.
//

import Foundation
import UIKit

extension String {
    // phone number extension coming soon..
}

extension NSAttributedString {
    
    convenience init?(string text:String, font:UIFont!, kerning: CGFloat!, color:UIColor!) {
        self.init(string: text, attributes: [NSKernAttributeName:kerning, NSFontAttributeName:font, NSForegroundColorAttributeName:color])
    }
}