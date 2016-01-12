//
//  ViewController.swift
//  School For Me
//
//  Created by Jamone Alexander Kelly on 12/6/15.
//  Copyright © 2015 Jamone Kelly. All rights reserved.
//

import UIKit
import FontAwesomeKit
import MapKit
import CoreLocation
import RealmSwift
import SVProgressHUD
import Async
import iAd

class MapVC: UIViewController, CLLocationManagerDelegate {
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var searchBar: UISearchBar!
    var locationManager : CLLocationManager!
    @IBOutlet var searchView: UIView!
    @IBOutlet var MVTopConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // VC Title
        self.title = "School For Me"
        searchView.backgroundColor = UIColor.flatSkyBlueColor()
        self.canDisplayBannerAds = true
        // Search Icon from FAK
        let searchIcon = FAKFontAwesome.searchIconWithSize(25).imageWithSize(CGSize(width: 30, height: 30))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: searchIcon, style: .Plain, target: self, action: "presentSearchView:")
        
        // Delegates
        self.mapView.delegate = self
        self.searchBar.delegate = self
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            // Request users location permission
            locationManager.requestWhenInUseAuthorization()
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
            self.mapView.setUserTrackingMode(MKUserTrackingMode.FollowWithHeading, animated: true)
            mapView.showsUserLocation = true // Show current location of user
        } else {
            let alert = UIAlertController(title: "Error", message: "Please enable location services in your settings application.", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        
        mapView.mapType = .Standard // Standard look of the map
        mapView.zoomEnabled = true // Allow the user to zoom on the map via finger gestures
        
        // Hack until I find a better way to do this..
        guard let onBoard : Bool = SFMData.objectForKey("onBoard") as? Bool else {
            return
        }
        
        if onBoard && School.total() > 0 {
            // load local db
            self.populate()
            
        }
    }
    
    // Better solution coming soon.. temporary
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let onBoard : Bool = SFMData.objectForKey("onBoard") as? Bool else {
            print("onBoard not set.. returning nil")
            SFMData.setBool(false, forKey: "onBoard")
            Global.userCoord = locations.last!.coordinate
            return
        }
        
        if !onBoard {
            SFMData.setBool(true, forKey: "onBoard")
            print("Updating results")
            Global.userCoord = locations.last!.coordinate
            School.fetchResults(withCoords: locations.last!.coordinate, andDistance: 25) { result in
                self.populate()
            }
        } else {
            Global.userCoord = locations.last!.coordinate
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // This can be modified using Notifications
    func populate() {
        SVProgressHUD.setDefaultMaskType(.Black)
        SVProgressHUD.showWithStatus("Loading school data..")
        var locArray = [SchoolAnnotation]()
        Async.background {
            let realm = try! Realm()
            let data = realm.objects(School)
            print("We have \(data.count) locations in the database")
            
            if data.count < 1 {
                // set onBoard to false.. exit and retry
                SFMData.setBool(false, forKey: "onBoard")
                return
            }
            
            var annotation = SchoolAnnotation()
            var coordinate = CLLocationCoordinate2D()
            for i in 0..<data.count {
                coordinate.latitude = (data[i].lat as NSString).doubleValue
                coordinate.longitude = (data[i].lon as NSString).doubleValue
                let schoolID = (data[i].id as NSString).integerValue
                annotation = SchoolAnnotation(title: data[i].school_name, district: data[i].district, coordinate: coordinate, schoolID: schoolID)
               locArray.append(annotation)
            }
        }.main {
            self.mapView.addAnnotations(locArray)
            self.mapView.showAnnotations(self.mapView.annotations, animated: true)
            SVProgressHUD.dismissWithDelay(1)
        }
    }
}

