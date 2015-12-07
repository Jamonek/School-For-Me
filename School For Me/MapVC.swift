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

class MapVC: UIViewController, MKMapViewDelegate {
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var searchBar: UISearchBar!
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // VC Title
        self.title = "School For Me"
        
        // Search Icon from FAK
        let searchIcon = FAKFontAwesome.searchIconWithSize(25).imageWithSize(CGSize(width: 30, height: 30))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: searchIcon, style: .Plain, target: self, action: nil)
        
        // Delegates
        self.mapView.delegate = self
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestWhenInUseAuthorization()
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            
            self.mapView.setUserTrackingMode(MKUserTrackingMode.FollowWithHeading, animated: true);
            
        } else {
            let alert = UIAlertController(title: "Error", message: "Please enable location services in your settings application.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        
        mapView.showsUserLocation = true // Show current location of user
        mapView.mapType = MKMapType.Standard // Standard look of the map
        mapView.zoomEnabled = true // Allow the user to zoom on the map via finger gestures
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

