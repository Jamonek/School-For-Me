//
//  Distance.swift
//  School For Me
//
//  Created by Jamone Alexander Kelly on 1/11/16.
//  Copyright © 2016 Jamone Kelly. All rights reserved.
//
// Updated swift-er version of `computeDistance` from Erica Sadun: http://ericasadun.com/2016/01/11/make-this-swift-er-coordinate-distances/

import Foundation

postfix operator ° {}
postfix func °(degrees: Double) -> Double {return degrees * M_PI / 180.0}

public struct Coordinate {
    public let latitude: Double, longitude: Double
    public enum EarthUnits: Double {case ImperialRadius = 3961.0,  MetricRadius = 6373.0}
    public func distanceFrom(coordinate: Coordinate, radius: EarthUnits = .ImperialRadius) -> Double {
        let (dLat, dLon) = (latitude - coordinate.latitude, longitude - coordinate.longitude)
        let (sqSinLat, sqSinLon) = (pow(sin(dLat° / 2.0), 2.0), pow(sin(dLon° / 2.0), 2.0))
        let a = sqSinLat + sqSinLon * cos(latitude°) * cos(coordinate.latitude°)
        let c = 2.0 * atan2(sqrt(a), sqrt(1.0 - a))
        return c * radius.rawValue
    }
}

// Example use
// let whitehouse = Coordinate(latitude: 38.898556, longitude: -77.037852)
// let fstreet = Coordinate(latitude: 38.897147, longitude: -77.043934)
// whitehouse.distanceFrom(fstreet)