//
//  MKPinAnnotationView.swift
//  School For Me
//
//  Created by Jamone Alexander Kelly on 1/6/16.
//  Copyright © 2016 Jamone Kelly. All rights reserved.
//

import UIKit
import MapKit

extension MKPinAnnotationView {
    // There is definitely a better way to do this and pretty redundant but this is an MVP..
    fileprivate struct AssociatedKeys {
        static var schoolID:Int?
    }
    
    var schoolID: Int? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.schoolID) as? Int
        }
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(self, &AssociatedKeys.schoolID, newValue as Int?, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
}
