//
//  DetailTV.swift
//  School For Me
//
//  Created by Jamone Alexander Kelly on 1/9/16.
//  Copyright © 2016 Jamone Kelly. All rights reserved.
//

import UIKit
import FontAwesomeKit
import RealmSwift
import MapKit

class DetailTV: UITableViewController {
    let realm = try! Realm()
    var schoolData: [School]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Select school: \(Global.schoolID)")
        let filter: NSPredicate = NSPredicate(format: "%K = %@", "id", String(Global.schoolID!))
        let data = realm.objects(School).filter(filter)
        schoolData = data.map{ $0 } // :<
        
        if let viewTitle: String = schoolData?[0].school_name {
            self.title = viewTitle
        }
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        self.tableView.userInteractionEnabled = true
        
        // Navigation items
        let reportIcon = FAKFontAwesome.flagIconWithSize(25)
        reportIcon.addAttribute(NSForegroundColorAttributeName, value: UIColor.redColor())
        let reportIconImage = reportIcon.imageWithSize(CGSize(width: 30, height: 30))
        let reportButton = UIBarButtonItem(image: reportIconImage, style: .Plain, target: self, action: nil)
        navigationItem.rightBarButtonItem = reportButton
        
        let closeIcon = FAKFontAwesome.chevronLeftIconWithSize(25).imageWithSize(CGSize(width: 30, height: 30))
        let closeButton = UIBarButtonItem(image: closeIcon, style: .Plain, target: self, action: "dismissView:")
        self.navigationItem.leftBarButtonItem = closeButton
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("detail") as! DetailTVC
        cell.detailLeftView.backgroundColor = UIColor.flatSkyBlueColor()
        cell.userInteractionEnabled = false
        switch indexPath.row {
        case 0:
            weak var schoolIcon = FAKFontAwesome.buildingIconWithSize(25)
            schoolIcon?.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor())
            cell.detailLeftImage.image = schoolIcon?.imageWithSize(CGSize(width: 30, height: 30))
            cell.detailLabel.text = schoolData![0].school_name
        case 1:
            weak var locationIcon = FAKFontAwesome.mapMarkerIconWithSize(25)
            locationIcon?.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor())
            cell.detailLeftImage.image = locationIcon?.imageWithSize(CGSize(width: 30, height: 30))
            cell.detailLabel.text = "\(schoolData![0].street) \(schoolData![0].city), \(schoolData![0].state) \(schoolData![0].zip)"
            cell.detailLabel.numberOfLines = 0
            cell.detailLabel.sizeToFit()
            let mapView = MKMapView(frame: CGRect(x: cell.bounds.width*0.108, y: cell.bounds.height+(cell.bounds.height*0.12), width: cell.bounds.width*0.60, height: cell.bounds.height+(cell.bounds.height*0.4)))
            let (lat, lng) = ((schoolData![0].lat as NSString).doubleValue, (schoolData![0].lon as NSString).doubleValue)
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lng)
            mapView.addAnnotation(SchoolAnnotation(title: schoolData![0].school_name, district: schoolData![0].district, coordinate: coordinate, schoolID: Global.schoolID!))
            mapView.showAnnotations(mapView.annotations, animated: true)
            mapView.setCenterCoordinate(coordinate, animated: true)
            mapView.zoomEnabled = false
            mapView.mapType = .Hybrid
            //mapView.userInteractionEnabled = false
            mapView.scrollEnabled = false
            cell.addSubview(mapView)
            cell.addConstraint(NSLayoutConstraint(item: cell.detailLeftView, attribute: .Height, relatedBy: .Equal, toItem: cell, attribute: .Height, multiplier: 1.0, constant: 0))
            cell.addConstraint(NSLayoutConstraint(item: cell.detailLeftImage, attribute: .CenterY, relatedBy: .Equal, toItem: cell, attribute: .CenterY, multiplier: 1.0, constant: 0))
        case 2:
            weak var phoneIcon = FAKFontAwesome.phoneIconWithSize(25)
            phoneIcon?.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor())
            cell.detailLeftImage.image = phoneIcon?.imageWithSize(CGSize(width: 30.0, height: 30.0))
            cell.detailLabel.text = schoolData![0].phone
        case 3:
            weak var infoIcon = FAKFontAwesome.infoIconWithSize(25)
            infoIcon?.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor())
            cell.detailLeftImage.image = infoIcon?.imageWithSize(CGSize(width: 30.0, height: 30.0))
            cell.detailLabel.text = schoolData![0].district
        case 4:
            weak var infoIcon = FAKFontAwesome.infoIconWithSize(25)
            infoIcon?.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor())
            cell.detailLeftImage.image = infoIcon?.imageWithSize(CGSize(width: 30.0, height: 30.0))
            cell.detailLabel.text = schoolData![0].county_name
        case 5:
            weak var gradIcon = FAKFontAwesome.graduationCapIconWithSize(25)
            gradIcon?.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor())
            cell.detailLeftImage.image = gradIcon?.imageWithSize(CGSize(width: 30.0, height: 30.0))
            cell.detailLabel.text = "\(schoolData![0].low_grade) - \(schoolData![0].high_grade)"
        case 6:
            var statusImage: UIImage!
            switch schoolData![0].charter {
            case "Yes":
                let statusIcon = FAKFontAwesome.checkIconWithSize(25)
                statusIcon.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor())
                statusImage = statusIcon.imageWithSize(CGSize(width: 30, height: 30))
            case "No":
                let statusIcon = FAKFontAwesome.timesIconWithSize(25)
                statusIcon.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor())
                statusImage = statusIcon.imageWithSize(CGSize(width: 30, height: 30))
            default:
                break
            }
            cell.detailLabel.text = "Charter"
            cell.detailLeftImage.image = statusImage
        case 7:
            var statusImage: UIImage!
            switch schoolData![0].magnet {
            case "Yes":
                let statusIcon = FAKFontAwesome.checkIconWithSize(25)
                statusIcon.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor())
                statusImage = statusIcon.imageWithSize(CGSize(width: 30, height: 30))
            case "No":
                let statusIcon = FAKFontAwesome.timesIconWithSize(25)
                statusIcon.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor())
                statusImage = statusIcon.imageWithSize(CGSize(width: 30, height: 30))
            default:
                break
            }
            cell.detailLabel.text = "Magnet"
            cell.detailLeftImage.image = statusImage
        default:
            break
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.row {
        case 1:
            return 159
        default:
            return 75.0
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    func dismissView(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
    }
}
