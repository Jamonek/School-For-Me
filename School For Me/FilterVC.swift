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
    @IBOutlet var closeButton: UIButton!
    @IBOutlet var sortBySegmentedControl: UISegmentedControl!
    @IBOutlet var charterSwitch: UISwitch!
    @IBOutlet var magnetSwitch: UISwitch!
    @IBOutlet var titleSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Buttons
        closeButton.addTarget(self, action: "dismissView:", forControlEvents: .TouchUpInside)
        
        // Switches
        charterSwitch.addTarget(self, action: "sendSwitchNotification:", forControlEvents: .TouchUpInside)
        magnetSwitch.addTarget(self, action: "sendSwitchNotification:", forControlEvents: .TouchUpInside)
        titleSwitch.addTarget(self, action: "sendSwitchNotification:", forControlEvents: .TouchUpInside)
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
