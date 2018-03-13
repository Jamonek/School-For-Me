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
    
    @objc static func fetchResults(withCoords coordinate: CLLocationCoordinate2D, andDistance distance: Int = 50, completion: @escaping (_ result: Bool) -> Void) {
        let param: [String: AnyObject] = [
            "lat": coordinate.latitude as AnyObject,
            "lng": coordinate.longitude as AnyObject,
            "distance": distance as AnyObject
        ]
        
        if !Reachability.isConnectedToNetwork() {
            completion(false)
            print("no connection called")
            return
        }
        
        Alamofire.request("https://jamonek.com/api/sfm/geo.php", method: .post,  parameters: param).responseJSON { response in
            print(response.request)
            if response.result.isFailure {
                print("API Failure")
                completion(false)
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
                            completion(false)
                        }
                    }
                }
                completion(true)
                return
            } else {
                print("Unable to parse JSON.. possibly no data")
                completion(false)
                return
            }
        }
    }
    
    @objc static func total() -> Int {
        let realm = try! Realm()
        let data = realm.objects(School.self)
        
        return data.count
    }
}
