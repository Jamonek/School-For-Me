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
    @objc var schoolData: [School]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let realm = try! Realm()
        let filter: NSPredicate = NSPredicate(format: "%K = %@", "id", String(Global.schoolID!))
        let data = realm.objects(School.self).filter(filter)
        self.schoolData = data.map{ $0 } // :<
        
        if let viewTitle: String = self.schoolData?[0].school_name {
            self.title = viewTitle
        }
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        self.tableView.isUserInteractionEnabled = true
        
        // Navigation items
        let reportIcon = FAKFontAwesome.flagIcon(withSize: 25)
        reportIcon?.addAttribute(NSAttributedStringKey.foregroundColor.rawValue, value: UIColor.red)
        let reportIconImage = reportIcon?.image(with: CGSize(width: 30, height: 30))
        let reportButton = UIBarButtonItem(image: reportIconImage, style: .plain, target: self, action: #selector(DetailTV.mailPop(_:)))
        navigationItem.rightBarButtonItem = reportButton
        
        let closeIcon = FAKFontAwesome.chevronLeftIcon(withSize: 25).image(with: CGSize(width: 30, height: 30))
        let closeButton = UIBarButtonItem(image: closeIcon, style: .plain, target: self, action: #selector(DetailTV.dismissView(_:)))
        self.navigationItem.leftBarButtonItem = closeButton
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detail") as! DetailTVC
        cell.detailLeftView.backgroundColor = UIColor.flatSkyBlue()
        cell.isUserInteractionEnabled = false
        switch indexPath.row {
        case 0:
            let schoolIcon = FAKFontAwesome.buildingIcon(withSize: 25)
            schoolIcon?.addAttribute(NSAttributedStringKey.foregroundColor.rawValue, value: UIColor.white)
            cell.detailLeftImage.image = schoolIcon?.image(with: CGSize(width: 30, height: 30))
            cell.detailLabel.text = schoolData![0].school_name
        case 1:
            let locationIcon = FAKFontAwesome.mapMarkerIcon(withSize: 25)
            locationIcon?.addAttribute(NSAttributedStringKey.foregroundColor.rawValue, value: UIColor.white)
            cell.detailLeftImage.image = locationIcon?.image(with: CGSize(width: 30, height: 30))
            cell.detailLabel.text = "\(schoolData![0].street) \(schoolData![0].city), \(schoolData![0].state) \(schoolData![0].zip)"
            cell.detailLabel.numberOfLines = 0
            cell.detailLabel.sizeToFit()
            // MKMapView Frame: frame: CGRect(x: cell.bounds.width*0.108, y: cell.bounds.height+(cell.bounds.height*0.12), width: cell.bounds.width*0.60, height: cell.bounds.height+(cell.bounds.height*0.4))
            let mapView = MKMapView(frame: CGRect(x: cell.bounds.width*0.108, y: cell.bounds.height, width: cell.bounds.width*0.60, height: cell.bounds.height+(cell.bounds.height*0.2)))
            let (lat, lng) = ((schoolData![0].lat as NSString).doubleValue, (schoolData![0].lon as NSString).doubleValue)
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lng)
            mapView.addAnnotation(SchoolAnnotation(title: schoolData![0].school_name, district: schoolData![0].district, coordinate: coordinate, schoolID: Global.schoolID!))
            mapView.showAnnotations(mapView.annotations, animated: true)
            mapView.setCenter(coordinate, animated: true)
            mapView.isZoomEnabled = false
            mapView.mapType = .hybrid
            //mapView.userInteractionEnabled = false
            mapView.isScrollEnabled = false
            cell.addSubview(mapView)
            cell.detailLeftView.translatesAutoresizingMaskIntoConstraints = false
            cell.addConstraint(NSLayoutConstraint(item: cell.detailLeftView, attribute: .top, relatedBy: .equal, toItem: cell.contentView, attribute: .top, multiplier: 1.0, constant: 0))
            cell.addConstraint(NSLayoutConstraint(item: cell.detailLeftView, attribute: .bottom, relatedBy: .equal, toItem: cell.contentView, attribute: .bottom, multiplier: 1.0, constant: 0))
            cell.addConstraint(NSLayoutConstraint(item: cell.detailLeftImage, attribute: .centerY, relatedBy: .equal, toItem: cell, attribute: .centerY, multiplier: 1.0, constant: 0))
            cell.addConstraint(NSLayoutConstraint(item: mapView, attribute: .bottom, relatedBy: .equal, toItem: cell.contentView, attribute: .bottom, multiplier: 1.0, constant: 0))
        case 2:
            let phoneIcon = FAKFontAwesome.phoneIcon(withSize: 25)
            phoneIcon?.addAttribute(NSAttributedStringKey.foregroundColor.rawValue, value: UIColor.white)
            cell.detailLeftImage.image = phoneIcon?.image(with: CGSize(width: 30.0, height: 30.0))
            cell.detailLabel.text = schoolData![0].phone
        case 3:
            let infoIcon = FAKFontAwesome.infoIcon(withSize: 25)
            infoIcon?.addAttribute(NSAttributedStringKey.foregroundColor.rawValue, value: UIColor.white)
            cell.detailLeftImage.image = infoIcon?.image(with: CGSize(width: 30.0, height: 30.0))
            cell.detailLabel.text = schoolData![0].district
        case 4:
            let infoIcon = FAKFontAwesome.infoIcon(withSize: 25)
            infoIcon?.addAttribute(NSAttributedStringKey.foregroundColor.rawValue, value: UIColor.white)
            cell.detailLeftImage.image = infoIcon?.image(with: CGSize(width: 30.0, height: 30.0))
            cell.detailLabel.text = schoolData![0].county_name
        case 5:
            let gradIcon = FAKFontAwesome.graduationCapIcon(withSize: 25)
            gradIcon?.addAttribute(NSAttributedStringKey.foregroundColor.rawValue, value: UIColor.white)
            cell.detailLeftImage.image = gradIcon?.image(with: CGSize(width: 30.0, height: 30.0))
            cell.detailLabel.text = "\(schoolData![0].low_grade) - \(schoolData![0].high_grade)"
        case 6:
            var statusImage: UIImage!
            switch schoolData![0].charter {
            case "Yes":
                let statusIcon = FAKFontAwesome.checkIcon(withSize: 25)
                statusIcon?.addAttribute(NSAttributedStringKey.foregroundColor.rawValue, value: UIColor.white)
                statusImage = statusIcon?.image(with: CGSize(width: 30, height: 30))
            default:
                let statusIcon = FAKFontAwesome.timesIcon(withSize: 25)
                statusIcon?.addAttribute(NSAttributedStringKey.foregroundColor.rawValue, value: UIColor.white)
                statusImage = statusIcon?.image(with: CGSize(width: 30, height: 30))
            }
            cell.detailLabel.text = "Charter"
            cell.detailLeftImage.image = statusImage
        case 7:
            var statusImage: UIImage!
            switch schoolData![0].magnet {
            case "Yes":
                let statusIcon = FAKFontAwesome.checkIcon(withSize: 25)
                statusIcon?.addAttribute(NSAttributedStringKey.foregroundColor.rawValue, value: UIColor.white)
                statusImage = statusIcon?.image(with: CGSize(width: 30, height: 30))
            default:
                let statusIcon = FAKFontAwesome.timesIcon(withSize: 25)
                statusIcon?.addAttribute(NSAttributedStringKey.foregroundColor.rawValue, value: UIColor.white)
                statusImage = statusIcon?.image(with: CGSize(width: 30, height: 30))
            }
            cell.detailLabel.text = "Magnet"
            cell.detailLeftImage.image = statusImage
        case 8:
            let userIcon = FAKFontAwesome.lineChartIcon(withSize: 25)
            userIcon?.addAttribute(NSAttributedStringKey.foregroundColor.rawValue, value: UIColor.white)
            cell.detailLeftImage.image = userIcon?.image(with: CGSize(width: 30, height: 30))
            let studentTeacherRatio = Double(schoolData![0].studentTeacherRatio)!.roundToPlaces(2)
            let freeLunchRatio = Double(schoolData![0].freeLunch)!.roundToPlaces(2)
            let reducedLunchStat = Double(schoolData![0].reducedLunch)!.roundToPlaces(2)
            cell.detailLabel.text = "Students: \(Double(schoolData![0].students)!) | Teachers: \(Double(schoolData![0].teachers)!) | S/T Ratio: \(studentTeacherRatio) | Free Lunch: \(freeLunchRatio) | Reduced Lunch: \(reducedLunchStat)"
            cell.detailLabel.numberOfLines = 0
            cell.detailLabel.sizeToFit()
        case 9:
            var statusImage: UIImage!
            switch schoolData![0].title1 {
            case "Yes":
                let statusIcon = FAKFontAwesome.checkIcon(withSize: 25)
                statusIcon?.addAttribute(NSAttributedStringKey.foregroundColor.rawValue, value: UIColor.white)
                statusImage = statusIcon?.image(with: CGSize(width: 30, height: 30))
            default:
                let statusIcon = FAKFontAwesome.timesIcon(withSize: 25)
                statusIcon?.addAttribute(NSAttributedStringKey.foregroundColor.rawValue, value: UIColor.white)
                statusImage = statusIcon?.image(with: CGSize(width: 30, height: 30))
            }
            cell.detailLabel.text = "Title 1"
            cell.detailLeftImage.image = statusImage
        default:
            break
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 1:
            return 159
        default:
            return 75.0
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    @objc func dismissView(_ sender: AnyObject) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func mailPop(_ sender: AnyObject) {
        let toRecipents = ["jamone.kelly@gmail.com"]
        let mc: MFMailComposeViewController = MFMailComposeViewController()
        mc.mailComposeDelegate = self
        if(!MFMailComposeViewController.canSendMail()) {
            let alert = UIAlertController(title: "Error", message: "Unable to send email from this device.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        let messageBody = "Please do not modify the data below this line. \n--------------------------------\n \(schoolData!.description)"
        
        mc.setSubject("SFM: Location report")
        mc.setMessageBody(messageBody, isHTML: false)
        mc.setToRecipients(toRecipents)
        
        self.present(mc, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller:MFMailComposeViewController, didFinishWith result:MFMailComposeResult, error:Error?) {
        switch result.rawValue {
        case MFMailComposeResult.cancelled.rawValue:
            print("Mail cancelled")
        case MFMailComposeResult.saved.rawValue:
            print("Mail saved")
        case MFMailComposeResult.sent.rawValue:
            print("Mail sent")
        case MFMailComposeResult.failed.rawValue:
            print("Mail sent failure: %@", error!.localizedDescription)
        default:
            break
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
}
