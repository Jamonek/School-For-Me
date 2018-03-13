//
//  DoubleExt.swift
//  School For Me
//
//  Created by Jamone Alexander Kelly on 1/11/16.
//  Copyright © 2016 Jamone Kelly. All rights reserved.
//

import UIKit

extension Double {
    var degreesToRadians : Double {
        return self * Double(M_PI) / 180.0
    }
    
    // Round method from http://stackoverflow.com/a/32581409
    /// Rounds the double to decimal places value
    func roundToPlaces(_ places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return round(self * divisor) / divisor
    }
}
