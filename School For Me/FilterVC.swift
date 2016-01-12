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
        let closeIcon = FAKFontAwesome.closeIconWithSize(25).imageWithSize(CGSize(width: 30, height: 30))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: closeIcon, style: .Plain, target: self, action: "dismissView:")
        
        let doneIcon = FAKFontAwesome.checkIconWithSize(25).imageWithSize(CGSize(width: 30, height: 30))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: doneIcon, style: .Plain, target: self, action: nil)
        
        // Switches
        charterSwitch.addTarget(self, action: "sendSwitchNotification:", forControlEvents: .TouchUpInside)
        magnetSwitch.addTarget(self, action: "sendSwitchNotification:", forControlEvents: .TouchUpInside)
        titleSwitch.addTarget(self, action: "sendSwitchNotification:", forControlEvents: .TouchUpInside)
        
        self.viewDivider1.backgroundColor = UIColor.flatSkyBlueColor()
        self.viewDivider2.backgroundColor = UIColor.flatSkyBlueColor()
    }
    
    @IBAction func distanceSliderChange(sender: UISlider) {
        let distance: Int = Int(sender.value)
        self.distanceLabel.text = "within \(distance) miles"
        self.distanceLabel.sizeToFit()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func dismissView(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func sendSwitchNotification(sender: UISwitch) {
        switch sender {
        case charterSwitch:
            NSNotificationCenter.defaultCenter().postNotificationName("charterSwitchNotification", object: nil)
        case magnetSwitch:
            NSNotificationCenter.defaultCenter().postNotificationName("magnetSwitchNotification", object: nil)
        case titleSwitch:
            NSNotificationCenter.defaultCenter().postNotificationName("titleSwitchNotification", object: nil)
        default:
            break
        }
    }
}
