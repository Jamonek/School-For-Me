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

class MapVC: UIViewController {
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var searchBar: UISearchBar!
    let locationManager = CLLocationManager()
    @IBOutlet var searchView: UIView!
    @IBOutlet var MVTopConstraint: NSLayoutConstraint!
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // VC Title
        self.title = "School For Me"
        searchView.backgroundColor = UIColor.flatSkyBlueColor()
        
        // Search Icon from FAK
        let searchIcon = FAKFontAwesome.searchIconWithSize(25).imageWithSize(CGSize(width: 30, height: 30))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: searchIcon, style: .Plain, target: self, action: "presentSearchView:")
        
        // Delegates
        self.mapView.delegate = self
        self.searchBar.delegate = self
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestWhenInUseAuthorization()
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            
            self.mapView.setUserTrackingMode(MKUserTrackingMode.FollowWithHeading, animated: true)
             mapView.showsUserLocation = true // Show current location of user
            School.fetchResults(withCoords: self.locationManager.location!.coordinate)
            
        } else {
            let alert = UIAlertController(title: "Error", message: "Please enable location services in your settings application.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        
        mapView.mapType = MKMapType.Standard // Standard look of the map
        mapView.zoomEnabled = true // Allow the user to zoom on the map via finger gestures
        self.populate()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func populate() {
        let data = realm.objects(School)
        print("We have \(data.count) locations in the database")
        for i in 0..<data.count {
            let lat = Double(data[i].lat)
            let lon = Double(data[i].lon)
            let coordinate = CLLocationCoordinate2D(latitude: lat!, longitude: lon!)
            let annotation = SchoolAnnotation(title: data[i].school_name, district: data[i].district, coordinate: coordinate)
            self.mapView.addAnnotation(annotation)
            print("\(data[i].school_name) has been added: Lat->\(data[i].lat) Lon->\(data[i].lon)")
        }
        self.mapView.showAnnotations(self.mapView.annotations, animated: true)
    }
}

