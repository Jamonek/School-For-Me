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

extension MapVC: MKMapViewDelegate, UISearchBarDelegate {
    func presentSearchView(sender: UIButton) {
        //self.navigationController!.navigationBarHidden = !self.navigationController!.navigationBarHidden
        //MVTopConstraint.constant = 45
        self.performSegueWithIdentifier("searchSegue", sender: self)
        print("Present pushed")
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        self.navigationController!.navigationBarHidden = !self.navigationController!.navigationBarHidden
        MVTopConstraint.constant = 0
        print("Cancel pushed")
    }
    
    func dismissSearch(sender: AnyObject) {
        print("Tapped")
        if self.searchBar.isFirstResponder() {
            self.resignFirstResponder()
        }
    }
}