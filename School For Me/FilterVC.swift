//
//  FilterVC.swift
//  School For Me
//
//  Created by Jamone Alexander Kelly on 12/15/15.
//  Copyright © 2015 Jamone Kelly. All rights reserved.
//

import UIKit
import FontAwesomeKit
import Async
import RealmSwift


class FilterVC: UIViewController {
    @IBOutlet var sortBySegmentedControl: UISegmentedControl!
    @IBOutlet var charterSwitch: UISwitch!
    @IBOutlet var magnetSwitch: UISwitch!
    @IBOutlet var titleSwitch: UISwitch!
    @IBOutlet var viewDivider1: UIView!
    @IBOutlet var viewDivider2: UIView!
    @IBOutlet var distanceLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // View Title
        self.title = "Filters"
        
        // UINavigation Button
        let closeIcon = FAKFontAwesome.closeIcon(withSize: 25).image(with: CGSize(width: 30, height: 30))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: closeIcon, style: .plain, target: self, action: #selector(FilterVC.dismissView(_:)))
        
        //let doneIcon = FAKFontAwesome.checkIconWithSize(25).imageWithSize(CGSize(width: 30, height: 30))
        //self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: doneIcon, style: .Plain, target: self, action: nil)
        
        // Switches
        charterSwitch.addTarget(self, action: #selector(FilterVC.sendSwitchNotification(_:)), for: .touchUpInside)
        magnetSwitch.addTarget(self, action: #selector(FilterVC.sendSwitchNotification(_:)), for: .touchUpInside)
        titleSwitch.addTarget(self, action: #selector(FilterVC.sendSwitchNotification(_:)), for: .touchUpInside)
        
        self.viewDivider1.backgroundColor = UIColor.flatSkyBlue
        self.viewDivider2.backgroundColor = UIColor.flatSkyBlue
    }
    
    @IBAction func distanceSliderChange(_ sender: UISlider) {
        let distance: Int = Int(sender.value)
        self.distanceLabel.text = "within \(distance) miles"
        self.distanceLabel.sizeToFit()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func dismissView(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func sendSwitchNotification(_ sender: UISwitch) {
        switch sender {
        case charterSwitch:
            NotificationCenter.default.post(name: Notification.Name(rawValue: "charterSwitchNotification"), object: nil)
        case magnetSwitch:
            NotificationCenter.default.post(name: Notification.Name(rawValue: "magnetSwitchNotification"), object: nil)
        case titleSwitch:
            NotificationCenter.default.post(name: Notification.Name(rawValue: "titleSwitchNotification"), object: nil)
        default:
            break
        }
    }
}
