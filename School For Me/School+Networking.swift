//
//  School+Networking.swift
//  School For Me
//
//  Created by Jamone Alexander Kelly on 12/13/15.
//  Copyright © 2015 Jamone Kelly. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import CoreLocation
import RealmSwift
extension School {
    
    static func fetchResults(withCoords coordinate: CLLocationCoordinate2D, andDistance distance: Int = 50) {
        let param: [String: AnyObject] = [
            "lat": coordinate.latitude,
            "lon": coordinate.longitude,
            "distance": distance
        ]
        
        let realm = try! Realm()
        
        Alamofire.request(.GET, "http://api.jamonek.com/sfm/geo.php", parameters: param).responseJSON { response in
            if response.result.error != nil {
                return
            }
            
            if let JSON: Array = response.result.value as? Array<[String: AnyObject]> {
                for dict in JSON {
                    try! realm.write {
                        let sch = School.mappedSchool(dict)
                        realm.add(sch, update: true)
                    }
                }
            }
        }
    }
}