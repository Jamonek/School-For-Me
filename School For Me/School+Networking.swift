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
import Async

extension School {
    
    static func fetchResults(withCoords coordinate: CLLocationCoordinate2D, andDistance distance: Int = 50, completion: (result: Bool) -> Void) {
        let param: [String: AnyObject] = [
            "lat": coordinate.latitude,
            "lng": coordinate.longitude,
            "distance": distance
        ]
        
        if !Reachability.isConnectedToNetwork() {
            completion(result: false)
            print("no connection called")
            return
        }
        
        Alamofire.Manager.sharedInstance.session.configuration.timeoutIntervalForResource = 5
        Alamofire.Manager.sharedInstance.session.configuration.timeoutIntervalForRequest = 5
        Alamofire.Manager.sharedInstance.request(.POST, "https://jamonek.com/api/sfm/geo.php", parameters: param).responseJSON { response in
            print(response.request)
            if response.result.isFailure {
                print("API Failure")
                completion(result: false)
                return
            }
            
            if let JSON: Array = response.result.value as? Array<[String: AnyObject]> {
                Async.background {
                    let realm = try! Realm()
                    for dict in JSON {
                        do {
                            try realm.write {
                                let sch = School.mappedSchool(dict)
                                realm.add(sch, update: true)
                            }
                        } catch {
                            print("Error adding location")
                            completion(result: false)
                        }
                    }
                }
                completion(result: true)
                return
            } else {
                print("Unable to parse JSON.. possibly no data")
                completion(result: false)
                return
            }
        }
    }
    
    static func total() -> Int {
        let realm = try! Realm()
        let data = realm.objects(School)
        
        return data.count
    }
}