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

extension MapVC: MKMapViewDelegate, UISearchBarDelegate {
    func presentSearchView(sender: UIButton) {
        //self.navigationController!.navigationBarHidden = !self.navigationController!.navigationBarHidden
        //MVTopConstraint.constant = 45
        self.performSegueWithIdentifier("searchSegue", sender: self)
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        self.navigationController!.navigationBarHidden = !self.navigationController!.navigationBarHidden
        MVTopConstraint.constant = 0
    }
    
    func dismissSearch(sender: AnyObject) {
        if self.searchBar.isFirstResponder() {
            self.resignFirstResponder()
        }
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        } else if annotation.isKindOfClass(SchoolAnnotation) {
            weak var pinView: MKPinAnnotationView? = mapView.dequeueReusableAnnotationViewWithIdentifier("pin") as? MKPinAnnotationView
            
            if pinView == nil {
                pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
                pinView?.pinTintColor = UIColor.redColor()
                pinView?.schoolID = (annotation as! SchoolAnnotation).schoolID // kind of redundant ??
            } else {
                pinView?.annotation = annotation
            }
        return pinView
        }
        
        return nil
    }
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
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
        let blurEffect = UIBlurEffect(style: .Light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = specialView.bounds
        specialView.addSubview(blurEffectView)
        specialView.tag = 309
        
        let (sX, sY) = (specialView.bounds.width, specialView.bounds.height)
        // better way to do all of this too
        // get details
        let realm = try! Realm()
        let sID = (view.annotation as! SchoolAnnotation).schoolID
        let filter: NSPredicate = NSPredicate(format: "%K = %@", "id", String(sID!))
        let data = realm.objects(School).filter(filter)
        let sData = data.map{ $0 } // :< 

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
        schoolNameLabel.textColor = UIColor.grayColor()
        specialView.addSubview(schoolNameLabel)
        
        schoolNameLabelContent.frame = CGRect(x: sX*0.4, y: sY*0.1, width: 15, height: 20)
        schoolNameLabelContent.sizeToFit()
        specialView.addSubview(schoolNameLabelContent)
        
        districtNameLabel.frame = CGRect(x: sX*0.22, y: sY * 0.2, width: 15, height: 20)
        districtNameLabel.sizeToFit()
        districtNameLabel.textColor = UIColor.grayColor()
        specialView.addSubview(districtNameLabel)
        
        districtNameLabelContent.frame = CGRect(x: sX*0.4, y: sY*0.2, width: 150, height: 35)
        districtNameLabelContent.numberOfLines = 0
        districtNameLabelContent.sizeToFit()
        specialView.addSubview(districtNameLabelContent)
        
        gradesNameLabel.frame = CGRect(x: sX*0.22, y: sY*0.39, width: 15, height: 20)
        gradesNameLabel.sizeToFit()
        gradesNameLabel.textColor = UIColor.grayColor()
        specialView.addSubview(gradesNameLabel)
        
        gradesLabelContent.frame = CGRect(x: sX*0.4, y: sY*0.39, width: 15, height: 20)
        gradesLabelContent.sizeToFit()
        specialView.addSubview(gradesLabelContent)
        
        phoneNumberLabel.frame = CGRect(x: sX*0.22, y: sY*0.48, width: 15, height: 20)
        phoneNumberLabel.sizeToFit()
        phoneNumberLabel.textColor = UIColor.grayColor()
        specialView.addSubview(phoneNumberLabel)
        
        phoneNumberLabelContent.frame = CGRect(x: sX*0.4, y: sY*0.48, width: 15, height: 20)
        phoneNumberLabelContent.sizeToFit()
        //phoneNumberLabelContent.editable = false // When I switch back to `UITextView`
        //phoneNumberLabelContent.dataDetectorTypes = .PhoneNumber
        specialView.addSubview(phoneNumberLabelContent)
        
        let seeMoreButton = UIButton()
        seeMoreButton.frame = CGRect(x: sX*0.22, y: sY*0.65, width: 200, height: 20)
        seeMoreButton.setAttributedTitle(NSAttributedString(string: "View More", font: UIFont.boldSystemFontOfSize(16), kerning: 1.0, color: UIColor.flatSkyBlueColor()), forState: .Normal)
        seeMoreButton.backgroundColor = UIColor.clearColor()
        specialView.addSubview(seeMoreButton)
        
        
        
        mapView.addSubview(specialView)
    }
    
    func mapView(mapView: MKMapView, didDeselectAnnotationView view: MKAnnotationView) {
        for subView in mapView.subviews {
            if subView.tag == 309 {
                UIView.animateWithDuration(1.0,
                    animations: {
                        subView.removeFromSuperview() // So this didn't work how I expected.. I'll come back to it
                })
            }
        }
    }
}