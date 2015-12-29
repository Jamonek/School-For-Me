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
        
        closeButton.addTarget(self, action: "dismissView:", forControlEvents: .TouchUpInside)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func dismissView(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
