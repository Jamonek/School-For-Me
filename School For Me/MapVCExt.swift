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
}