//
//  SchoolAnnotations.swift
//  School For Me
//
//  Created by Jamone Alexander Kelly on 12/13/15.
//  Copyright © 2015 Jamone Kelly. All rights reserved.
//

import MapKit

class SchoolAnnotation: NSObject, MKAnnotation {
    var title: String?
    let district: String
    let coordinate: CLLocationCoordinate2D
    var subtitle: String? {
        return district
    }
    
    init(title: String, district: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.district = district
        self.coordinate = coordinate
        super.init()
    }
}
