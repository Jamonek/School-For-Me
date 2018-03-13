//
//  Global.swift
//  School For Me
//
//  Created by Jamone Alexander Kelly on 1/9/16.
//  Copyright © 2016 Jamone Kelly. All rights reserved.
//

import Foundation
import MapKit

struct Global {
    static var schoolID: Int? // Work around for passing the selected location ID
    static var userCoord: CLLocationCoordinate2D?
    
    func computeDistance(_ coordinates: CLLocationCoordinate2D, sCoordinates: CLLocationCoordinate2D) -> Double {
        // User coordinate
        let uLat: Double = coordinates.latitude
        let uLng: Double = coordinates.longitude
        // School coordinate
        let sLat: Double = sCoordinates.latitude
        let sLng: Double = sCoordinates.longitude
        
        let radius: Double = 3961.0 // Miles
        
        let deltaP = (sLat.degreesToRadians - uLat.degreesToRadians)
        let deltaL = (sLng.degreesToRadians - uLng.degreesToRadians)
        let a = sin(deltaP/2) * sin(deltaP/2) + cos(uLat.degreesToRadians) * cos(sLat.degreesToRadians) * sin(deltaL/2) * sin(deltaL/2)
        let c = 2 * atan2(sqrt(a), sqrt(1-a))
        let d = radius * c
        
        return d.roundToPlaces(2) // distance in miles rounded to 2 decimal places
    }
}
