//
//  Search.swift
//  School For Me
//
//  Created by Jamone Alexander Kelly on 12/13/15.
//  Copyright © 2015 Jamone Kelly. All rights reserved.
//

import UIKit
import FontAwesomeKit
import DZNEmptyDataSet
import RealmSwift
import MapKit

class Search: UIViewController, DZNEmptyDataSetDelegate, DZNEmptyDataSetSource, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tableView: UITableView!
    var filteredResults = [School]()
    let realm = try! Realm()
    var searchString: String = String()
    var schoolData: Results<School>?
    let mainQueue = NSOperationQueue.mainQueue()
    var searchDict = ["title1":false, "charter":false, "magnet":false] // false represents off state, true being filter is applied
    let g = Global()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Search"

        schoolData = realm.objects(School)
        // Icons from FAK
        let listIcon = FAKFontAwesome.listUlIconWithSize(25).imageWithSize(CGSize(width: 30, height: 30))
        _ = UIBarButtonItem(image: listIcon, style: .Plain, target: self, action: nil) // Removed from navigation until feature is complete
        
        //let closeIcon = FAKFontAwesome.closeIconWithSize(25).imageWithSize(CGSize(width: 30, height: 30))
        //let closeIcon2 = FAKFontAwesome.angleLeftIconWithSize(25).imageWithSize(CGSize(width: 30, height: 30))
        let closeIcon3 = FAKFontAwesome.chevronLeftIconWithSize(25).imageWithSize(CGSize(width: 30, height: 30))
        let filterIcon = FAKFontAwesome.filterIconWithSize(25).imageWithSize(CGSize(width: 30, height: 30))
        let filterButton = UIBarButtonItem(image: filterIcon, style: .Plain, target: self, action: "presentFilterOptions:")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: closeIcon3, style: .Plain, target: self, action: "dismissView:")
        self.navigationItem.rightBarButtonItems = [filterButton]
        
        self.searchBar.delegate = self
        self.tableView.emptyDataSetDelegate = self
        self.tableView.emptyDataSetSource = self
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        self.tableView.keyboardDismissMode = .OnDrag
        //self.searchBar.backgroundColor = UIColor.flatSkyBlueColor()
        //self.searchBar.barTintColor = UIColor.flatSkyBlueColor()
        
        // Observers
        NSNotificationCenter.defaultCenter().addObserverForName("titleSwitchNotification", object: nil, queue: mainQueue,
            usingBlock: { _ in
                if self.searchDict["title1"]! {
                    // remove filter
                    self.searchDict["title1"] = false
                } else {
                    // apply filter
                    self.searchDict["titl1"] = true
                }
        })
        NSNotificationCenter.defaultCenter().addObserverForName("magnetSwitchNotification", object: nil, queue: mainQueue,
            usingBlock: { _ in
                if self.searchDict["magnet"]! {
                    // remove filter
                    self.searchDict["magnet"] = false
                } else {
                    // apply filter
                    self.searchDict["magnet"] = true
                }
        })
        NSNotificationCenter.defaultCenter().addObserverForName("charterSwitchNotification", object: nil, queue: mainQueue,
            usingBlock: { _ in
                if self.searchDict["charter"]! {
                    // remove filter
                    self.searchDict["charter"] = false
                } else {
                    // apply filter
                    self.searchDict["charter"] = true
                }
        })
    }
    
    func dismissView(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    deinit {
        self.tableView.emptyDataSetSource = nil
        self.tableView.emptyDataSetDelegate = nil
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "charterSwitchNotification", object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "magnetSwitchNotification", object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "titleSwitchNotification", object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let attributes = [
            NSFontAttributeName: UIFont.boldSystemFontOfSize(18.0),
            NSForegroundColorAttributeName: UIColor.blackColor()
        ]
        
        return NSAttributedString(string: "No search results", attributes: attributes)
    }
    
    func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "When you search for a school, your results will appear here."
        
        let paragraph = NSMutableParagraphStyle()
        
        paragraph.lineBreakMode = .ByWordWrapping
        paragraph.alignment = .Center
        
        let attributes = [
            NSFontAttributeName: UIFont.systemFontOfSize(14.0),
            NSForegroundColorAttributeName: UIColor.blackColor(),
            NSParagraphStyleAttributeName: paragraph
        ]
        
        return NSAttributedString(string: text, attributes: attributes)
    }
    
    func imageForEmptyDataSet(scrollView: UIScrollView!) -> UIImage! {
        let gradIcon: UIImage = FAKFontAwesome.graduationCapIconWithSize(85).imageWithSize(CGSize(width: 90, height: 90))
        return gradIcon
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! SearchCells
        cell.backgroundColor = UIColor.flatSkyBlueColor()
        cell.schoolName.text = filteredResults[indexPath.row].school_name
        cell.schoolDistrict.text = filteredResults[indexPath.row].district
        let sCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: Double(filteredResults[indexPath.row].lat)!, longitude: Double(filteredResults[indexPath.row].lon)!)
        let distance: Double = g.computeDistance(Global.userCoord!, sCoordinates: sCoordinate)
        print("Location: \(filteredResults[indexPath.row].lat) \(filteredResults[indexPath.row].lon)")
        cell.schoolDistance.text = "\(distance.roundToPlaces(2)) miles away"
        cell.schoolName.sizeToFit()
        cell.schoolDistrict.sizeToFit()
        cell.schoolDistance.sizeToFit()
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 92
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredResults.count
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        Global.schoolID = (filteredResults[indexPath.row].id as NSString).integerValue
        self.showDetailTV(nil)
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        filterSchools(searchString: searchText)
    }
    
    func filterSchools(searchString searchText: String = "") {
        if searchText.isEmpty {
            filteredResults.removeAll()
            self.tableView.reloadData()
            self.searchString = ""
            if searchBar.isFirstResponder() {
                searchBar.resignFirstResponder()
            }
            return
        }
        filteredResults.removeAll()
        self.searchString = searchText
        var predicates = [NSPredicate(format: "school_name CONTAINS[c] %@", searchText)]
        
        if self.searchDict["charter"]! {
                predicates.append(NSPredicate(format: "charter = 'Yes'"))
        }
        
        if self.searchDict["magnet"]! {
            predicates.append(NSPredicate(format: "magnet = 'Yes'"))
        }
        
        let predicate = NSCompoundPredicate(orPredicateWithSubpredicates: predicates)
        let results = schoolData!.filter(predicate)
        for result in results {
            filteredResults.append(result)
        }
        self.tableView.reloadData()
    }
    
    func presentFilterOptions(sender: UIBarButtonItem) {
        self.performSegueWithIdentifier("filterSegue", sender: self)
    }
}
