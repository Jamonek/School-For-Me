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
import Async
import MessageUI

class DetailTV: UITableViewController, MFMailComposeViewControllerDelegate {
    var schoolData: [School]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let realm = try! Realm()
        let filter: NSPredicate = NSPredicate(format: "%K = %@", "id", String(Global.schoolID!))
        let data = realm.objects(School).filter(filter)
        self.schoolData = data.map{ $0 } // :<
        
        if let viewTitle: String = self.schoolData?[0].school_name {
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
        let reportButton = UIBarButtonItem(image: reportIconImage, style: .Plain, target: self, action: "mailPop:")
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
            // MKMapView Frame: frame: CGRect(x: cell.bounds.width*0.108, y: cell.bounds.height+(cell.bounds.height*0.12), width: cell.bounds.width*0.60, height: cell.bounds.height+(cell.bounds.height*0.4))
            let mapView = MKMapView(frame: CGRect(x: cell.bounds.width*0.108, y: cell.bounds.height, width: cell.bounds.width*0.60, height: cell.bounds.height+(cell.bounds.height*0.2)))
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
            cell.detailLeftView.translatesAutoresizingMaskIntoConstraints = false
            cell.addConstraint(NSLayoutConstraint(item: cell.detailLeftView, attribute: .Top, relatedBy: .Equal, toItem: cell.contentView, attribute: .Top, multiplier: 1.0, constant: 0))
            cell.addConstraint(NSLayoutConstraint(item: cell.detailLeftView, attribute: .Bottom, relatedBy: .Equal, toItem: cell.contentView, attribute: .Bottom, multiplier: 1.0, constant: 0))
            cell.addConstraint(NSLayoutConstraint(item: cell.detailLeftImage, attribute: .CenterY, relatedBy: .Equal, toItem: cell, attribute: .CenterY, multiplier: 1.0, constant: 0))
            cell.addConstraint(NSLayoutConstraint(item: mapView, attribute: .Bottom, relatedBy: .Equal, toItem: cell.contentView, attribute: .Bottom, multiplier: 1.0, constant: 0))
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
            default:
                let statusIcon = FAKFontAwesome.timesIconWithSize(25)
                statusIcon.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor())
                statusImage = statusIcon.imageWithSize(CGSize(width: 30, height: 30))
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
            default:
                let statusIcon = FAKFontAwesome.timesIconWithSize(25)
                statusIcon.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor())
                statusImage = statusIcon.imageWithSize(CGSize(width: 30, height: 30))
            }
            cell.detailLabel.text = "Magnet"
            cell.detailLeftImage.image = statusImage
        case 8:
            let userIcon = FAKFontAwesome.lineChartIconWithSize(25)
            userIcon.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor())
            cell.detailLeftImage.image = userIcon.imageWithSize(CGSize(width: 30, height: 30))
            cell.detailLabel.text = "Students: \(Int(schoolData![0].students)) | Teachers: \(Int(schoolData![0].teachers)) | Student/Teacher Ratio: \(Double(schoolData![0].studentTeacherRatio)?.roundToPlaces(2)) | Free Lunch: \(Double(schoolData![0].freeLunch)?.roundToPlaces(2)) | Reduced Lunch: \(Double(schoolData![0].reducedLunch)?.roundToPlaces(2))"
            cell.detailLabel.numberOfLines = 0
            cell.detailLabel.sizeToFit()
        case 9:
            var statusImage: UIImage!
            switch schoolData![0].title1 {
            case "Yes":
                let statusIcon = FAKFontAwesome.checkIconWithSize(25)
                statusIcon.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor())
                statusImage = statusIcon.imageWithSize(CGSize(width: 30, height: 30))
            default:
                let statusIcon = FAKFontAwesome.timesIconWithSize(25)
                statusIcon.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor())
                statusImage = statusIcon.imageWithSize(CGSize(width: 30, height: 30))
            }
            cell.detailLabel.text = "Title 1"
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
        return 10
    }
    
    func dismissView(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func mailPop(sender: AnyObject) {
        let toRecipents = ["jamone.kelly@gmail.com"]
        let mc: MFMailComposeViewController = MFMailComposeViewController()
        mc.mailComposeDelegate = self
        if(!MFMailComposeViewController.canSendMail()) {
            let alert = UIAlertController(title: "Error", message: "Unable to send email from this device.", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        
        let messageBody = "Please do not modify the data below this line. \n--------------------------------\n \(schoolData!.description)"
        
        mc.setSubject("SFM: Location report")
        mc.setMessageBody(messageBody, isHTML: false)
        mc.setToRecipients(toRecipents)
        
        self.presentViewController(mc, animated: true, completion: nil)
    }
    
    func mailComposeController(controller:MFMailComposeViewController, didFinishWithResult result:MFMailComposeResult, error:NSError?) {
        switch result.rawValue {
        case MFMailComposeResultCancelled.rawValue:
            print("Mail cancelled")
        case MFMailComposeResultSaved.rawValue:
            print("Mail saved")
        case MFMailComposeResultSent.rawValue:
            print("Mail sent")
        case MFMailComposeResultFailed.rawValue:
            print("Mail sent failure: %@", error!.localizedDescription)
        default:
            break
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
    }
}
