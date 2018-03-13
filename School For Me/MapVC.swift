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
import MoPub

class MapVC: UIViewController, CLLocationManagerDelegate, MPAdViewDelegate {
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var searchBar: UISearchBar!
    @objc var locationManager : CLLocationManager!
    @IBOutlet var searchView: UIView!
    @IBOutlet var MVTopConstraint: NSLayoutConstraint!
    
    @objc var adView: MPAdView = MPAdView(adUnitId: "ea61ed364b0b4be4a2c61f6655cb9153", size: MOPUB_BANNER_SIZE)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.adView.delegate = self
        
        // Positions the ad at the bottom, with the correct size
        self.adView.frame = CGRect(x: 0, y: self.view.bounds.size.height - MOPUB_BANNER_SIZE.height,
                                       width: view.bounds.size.width, height: MOPUB_BANNER_SIZE.height)
        self.view.addSubview(self.adView)
        
        // Loads the ad over the network
        self.adView.loadAd()

        
        // VC Title
        self.title = "School For Me"
        searchView.backgroundColor = UIColor.flatSkyBlue
        // Search Icon from FAK
        let searchIcon = FAKFontAwesome.searchIcon(withSize: 25).image(with: CGSize(width: 30, height: 30))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: searchIcon, style: .plain, target: self, action: #selector(MapVC.presentSearchView(_:)))
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show(withStatus: "Contacting school for me server..")
        
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
            //self.mapView.setUserTrackingMode(MKUserTrackingMode.FollowWithHeading, animated: true)
            mapView.showsUserLocation = true // Show current location of user
        } else {
            let alert = UIAlertController(title: "Error", message: "Please enable location services in your settings application.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        if !Reachability.isConnectedToNetwork() {
            let alert = UIAlertController(title: "Error", message: "A network connection is unavailable at the moment.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.locationManager.stopUpdatingLocation()
            SVProgressHUD.dismiss()
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        mapView.mapType = .standard // Standard look of the map
        mapView.isZoomEnabled = true // Allow the user to zoom on the map via finger gestures
        
        // Hack until I find a better way to do this..
        guard let onBoard : Bool = SFMData.object(forKey: "onBoard") as? Bool else {
            return
        }
        
        if onBoard && School.total() > 0 {
            // load local db
            SVProgressHUD.dismiss()
            self.populate()
        }
    }
    
    func viewControllerForPresentingModalView() -> UIViewController {
        return self
    }
    
    // Better solution coming soon.. temporary
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //print("Coord: \(locations.last!.coordinate)")
        guard let onBoard : Bool = SFMData.object(forKey: "onBoard") as? Bool else {
            print("onBoard not set.. returning nil")
            SFMData.set(false, forKey: "onBoard")
            Global.userCoord = locations.last!.coordinate
            return
        }
        
        if !onBoard {
            SFMData.set(true, forKey: "onBoard")
            print("Updating results")
            
            Global.userCoord = locations.last!.coordinate
            School.fetchResults(withCoords: locations.last!.coordinate, andDistance: 25) { result in
                if result {
                    SVProgressHUD.dismiss()
                    self.populate()
                } else {
                    let alert = UIAlertController(title: "Error", message: "Unable to find any schools within your area. Check back soon.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                    self.locationManager.stopUpdatingLocation()
                    SVProgressHUD.dismiss()
                    self.present(alert, animated: true, completion: nil)
                    return
                }
            }
        } else {
            Global.userCoord = locations.last!.coordinate
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // This can be modified using Notifications
    @objc func populate() {
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show(withStatus: "Loading school data..")
        var locArray = [SchoolAnnotation]()
        Async.background {
            let realm = try! Realm()
            let data = realm.objects(School.self)
            
            if data.count < 1 {
                // set onBoard to false.. exit and retry
                SFMData.set(false, forKey: "onBoard")
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
            SVProgressHUD.dismiss()
        }
    }
}

