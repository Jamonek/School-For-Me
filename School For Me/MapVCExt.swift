//
//  MapVCExt.swift
//  School For Me
//
//  Created by Jamone Alexander Kelly on 12/7/15.
//  Copyright © 2015 Jamone Kelly. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreLocation
import FontAwesomeKit
import RealmSwift
import Async

extension MapVC: MKMapViewDelegate, UISearchBarDelegate {
    @objc func presentSearchView(_ sender: UIButton) {
        //self.navigationController!.navigationBarHidden = !self.navigationController!.navigationBarHidden
        //MVTopConstraint.constant = 45
        self.performSegue(withIdentifier: "searchSegue", sender: self)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.navigationController!.isNavigationBarHidden = !self.navigationController!.isNavigationBarHidden
        MVTopConstraint.constant = 0
    }
    
    @objc func dismissSearch(_ sender: AnyObject) {
        if self.searchBar.isFirstResponder {
            self.resignFirstResponder()
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        } else if annotation.isKind(of: SchoolAnnotation.self) {
            if let pinView: MKPinAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "pin") as? MKPinAnnotationView {
                pinView.annotation = annotation
                return pinView
            } else {
                let pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
                pinView.pinTintColor = UIColor.red
                return pinView
            }
        }
        return nil
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if mapView.viewWithTag(309) != nil {
            print(mapView.subviews)
            for subView in mapView.subviews {
                if subView.tag == 309 {
                    subView.removeFromSuperview()
                }
            }
        }

        let (x, y) = (mapView.bounds.width, mapView.bounds.height)
        let specialView: UIView = UIView(frame: CGRect(x: 0, y: y*0.42, width: x, height: y*0.6))
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = specialView.bounds
        specialView.addSubview(blurEffectView)
        specialView.tag = 309
        
        let (sX, sY) = (specialView.bounds.width, specialView.bounds.height)
        // better way to do all of this too
        // get details
        var sData: [School]!
        var data: Results<School>!
        
        let realm = try! Realm()
        let sID = (view.annotation as! SchoolAnnotation).schoolID
        let filter: NSPredicate = NSPredicate(format: "%K = %@", "id", String(sID!))
        data = realm.objects(School.self).filter(filter)
        sData = data.map{ $0 } // :<
        
        
        // Set our global var for passing selected location data
        Global.schoolID = (sData[0].id as NSString).integerValue
        
        // Preview Labels
        let schoolNameLabel = UILabel()
        schoolNameLabel.text = "School"

        let schoolNameLabelContent = UILabel()
        schoolNameLabelContent.text = sData[0].school_name
        
        let districtNameLabel = UILabel()
        districtNameLabel.text = "District"
        
        let districtNameLabelContent = UILabel()
        districtNameLabelContent.text = sData[0].district
        
        let gradesNameLabel = UILabel()
        gradesNameLabel.text = "Grades"
        
        let gradesLabelContent = UILabel()
        gradesLabelContent.text = "\(sData[0].low_grade) - \(sData[0].high_grade)"
        
        let phoneNumberLabel = UILabel()
        phoneNumberLabel.text = "Call"
        
        let phoneNumberLabelContent = UILabel()
        phoneNumberLabelContent.text = sData[0].phone

        // lil bit of number magic :o
        // definitely a better way to do this lol I'll come back to it as well
        schoolNameLabel.frame = CGRect(x: sX*0.22, y: sY * 0.1, width: 15, height: 20)
        schoolNameLabel.sizeToFit()
        schoolNameLabel.textColor = UIColor.gray
        specialView.addSubview(schoolNameLabel)
        
        schoolNameLabelContent.frame = CGRect(x: sX*0.4, y: sY*0.1, width: 15, height: 20)
        schoolNameLabelContent.sizeToFit()
        specialView.addSubview(schoolNameLabelContent)
        
        districtNameLabel.frame = CGRect(x: sX*0.22, y: sY * 0.2, width: 15, height: 20)
        districtNameLabel.sizeToFit()
        districtNameLabel.textColor = UIColor.gray
        specialView.addSubview(districtNameLabel)
        
        districtNameLabelContent.frame = CGRect(x: sX*0.4, y: sY*0.2, width: 150, height: 35)
        districtNameLabelContent.numberOfLines = 0
        districtNameLabelContent.sizeToFit()
        specialView.addSubview(districtNameLabelContent)
        
        gradesNameLabel.frame = CGRect(x: sX*0.22, y: sY*0.39, width: 15, height: 20)
        gradesNameLabel.sizeToFit()
        gradesNameLabel.textColor = UIColor.gray
        specialView.addSubview(gradesNameLabel)
        
        gradesLabelContent.frame = CGRect(x: sX*0.4, y: sY*0.39, width: 15, height: 20)
        gradesLabelContent.sizeToFit()
        specialView.addSubview(gradesLabelContent)
        
        phoneNumberLabel.frame = CGRect(x: sX*0.22, y: sY*0.48, width: 15, height: 20)
        phoneNumberLabel.sizeToFit()
        phoneNumberLabel.textColor = UIColor.gray
        specialView.addSubview(phoneNumberLabel)
        
        phoneNumberLabelContent.frame = CGRect(x: sX*0.4, y: sY*0.48, width: 15, height: 20)
        phoneNumberLabelContent.sizeToFit()
        //phoneNumberLabelContent.editable = false // When I switch back to `UITextView`
        //phoneNumberLabelContent.dataDetectorTypes = .PhoneNumber
        specialView.addSubview(phoneNumberLabelContent)
        
        let seeMoreButton = UIButton()
        seeMoreButton.frame = CGRect(x: sX*0.22, y: sY*0.65, width: 200, height: 20)
        seeMoreButton.setAttributedTitle(NSAttributedString(string: "Expand", font: UIFont.boldSystemFont(ofSize: 16), kerning: 1.0, color: UIColor.flatSkyBlue()), for: [])
        seeMoreButton.backgroundColor = UIColor.clear
        seeMoreButton.addTarget(self, action: #selector(UIViewController.showDetailTV(_:)), for: .touchUpInside)
        specialView.addSubview(seeMoreButton)
        
        
        
        mapView.addSubview(specialView)
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        for subView in mapView.subviews {
            if subView.tag == 309 {
                UIView.animate(withDuration: 1.0,
                    animations: {
                        subView.removeFromSuperview() // So this didn't work how I expected.. I'll come back to it
                })
            }
        }
    }
}
