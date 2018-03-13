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
    let mainQueue = OperationQueue.main
    var searchDict = ["title1":false, "charter":false, "magnet":false] // false represents off state, true being filter is applied
    let g = Global()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Search"

        schoolData = realm.objects(School)
        // Icons from FAK
        let listIcon = FAKFontAwesome.listUlIcon(withSize: 25).image(with: CGSize(width: 30, height: 30))
        _ = UIBarButtonItem(image: listIcon, style: .plain, target: self, action: nil) // Removed from navigation until feature is complete
        
        //let closeIcon = FAKFontAwesome.closeIconWithSize(25).imageWithSize(CGSize(width: 30, height: 30))
        //let closeIcon2 = FAKFontAwesome.angleLeftIconWithSize(25).imageWithSize(CGSize(width: 30, height: 30))
        let closeIcon3 = FAKFontAwesome.chevronLeftIcon(withSize: 25).image(with: CGSize(width: 30, height: 30))
        let filterIcon = FAKFontAwesome.filterIcon(withSize: 25).image(with: CGSize(width: 30, height: 30))
        let filterButton = UIBarButtonItem(image: filterIcon, style: .plain, target: self, action: #selector(Search.presentFilterOptions(_:)))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: closeIcon3, style: .plain, target: self, action: #selector(Search.dismissView(_:)))
        self.navigationItem.rightBarButtonItems = [filterButton]
        
        self.searchBar.delegate = self
        self.tableView.emptyDataSetDelegate = self
        self.tableView.emptyDataSetSource = self
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        self.tableView.keyboardDismissMode = .onDrag
        //self.searchBar.backgroundColor = UIColor.flatSkyBlueColor()
        //self.searchBar.barTintColor = UIColor.flatSkyBlueColor()
        
        // Observers
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "titleSwitchNotification"), object: nil, queue: mainQueue,
            using: { _ in
                print("Title1 notification hit")
                if self.searchDict["title1"]! {
                    // remove filter
                    self.searchDict["title1"] = false
                } else {
                    // apply filter
                    self.searchDict["title1"] = true
                }
                self.updateResults()
        })
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "magnetSwitchNotification"), object: nil, queue: mainQueue,
            using: { _ in
                print("Magnet notification hit")
                if self.searchDict["magnet"]! {
                    // remove filter
                    self.searchDict["magnet"] = false
                } else {
                    // apply filter
                    self.searchDict["magnet"] = true
                }
                self.updateResults()
        })
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "charterSwitchNotification"), object: nil, queue: mainQueue,
            using: { _ in
                print("Charter notification hit")
                if self.searchDict["charter"]! {
                    // remove filter
                    self.searchDict["charter"] = false
                } else {
                    // apply filter
                    self.searchDict["charter"] = true
                }
                self.updateResults()
        })
    }
    
    func dismissView(_ sender: AnyObject) {
        self.navigationController?.popViewController(animated: true)
    }
    
    deinit {
        self.tableView.emptyDataSetSource = nil
        self.tableView.emptyDataSetDelegate = nil
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "charterSwitchNotification"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "magnetSwitchNotification"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "titleSwitchNotification"), object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let attributes = [
            NSFontAttributeName: UIFont.boldSystemFont(ofSize: 18.0),
            NSForegroundColorAttributeName: UIColor.black
        ]
        
        return NSAttributedString(string: "No search results", attributes: attributes)
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "When you search for a school, your results will appear here."
        
        let paragraph = NSMutableParagraphStyle()
        
        paragraph.lineBreakMode = .byWordWrapping
        paragraph.alignment = .center
        
        let attributes = [
            NSFontAttributeName: UIFont.systemFont(ofSize: 14.0),
            NSForegroundColorAttributeName: UIColor.black,
            NSParagraphStyleAttributeName: paragraph
        ]
        
        return NSAttributedString(string: text, attributes: attributes)
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        let gradIcon: UIImage = FAKFontAwesome.graduationCapIcon(withSize: 85).image(with: CGSize(width: 90, height: 90))
        return gradIcon
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! SearchCells
        cell.backgroundColor = UIColor.flatSkyBlueColor()
        cell.schoolName.text = filteredResults[indexPath.row].school_name
        cell.schoolDistrict.text = filteredResults[indexPath.row].district
        let sCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: Double(filteredResults[indexPath.row].lat)!, longitude: Double(filteredResults[indexPath.row].lon)!)
        let distance: Double = g.computeDistance(Global.userCoord!, sCoordinates: sCoordinate)
        cell.schoolDistance.text = "\(distance.roundToPlaces(2)) miles away"
        cell.schoolName.sizeToFit()
        cell.schoolDistrict.sizeToFit()
        cell.schoolDistance.sizeToFit()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 92
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredResults.count
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Global.schoolID = (filteredResults[indexPath.row].id as NSString).integerValue
        self.showDetailTV(nil)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterSchools(searchString: searchText)
    }
    
    // Quick, and dirty way to attempt filtering
    // Pretty redundant.. refactor coming soon
    // Rush to market for 1.0 then rewrite for quality
    func updateResults() -> Void {
        var predicates = [NSPredicate]()
        
        if !self.searchString.isEmpty {
            let or1 = NSPredicate(format: "school_name CONTAINS[c] %@", searchString)
            let or2 = NSPredicate(format: "city CONTAINS[c] %@", searchString)
            predicates = [or1, or2]
        }
        
        if self.searchDict["charter"]! {
            predicates.append(NSPredicate(format: "charter = 'Yes'"))
        }
        
        if self.searchDict["magnet"]! {
            predicates.append(NSPredicate(format: "magnet = 'Yes'"))
        }
        
        if self.searchDict["title1"]! {
            predicates.append(NSPredicate(format: "title1 = 'Yes'"))
        }
        
        let predicate = NSCompoundPredicate(orPredicateWithSubpredicates: predicates)
        let results = schoolData!.filter(predicate)
        for result in results {
            filteredResults.append(result)
        }
        self.tableView.reloadData()
    }
    
    func filterSchools(searchString searchText: String = "") {
        if searchText.isEmpty {
            filteredResults.removeAll()
            self.tableView.reloadData()
            self.searchString = ""
            if searchBar.isFirstResponder {
                searchBar.resignFirstResponder()
            }
            return
        }
        filteredResults.removeAll()
        self.searchString = searchText
        let or1 = NSPredicate(format: "school_name CONTAINS[c] %@", searchText)
        let or2 = NSPredicate(format: "city CONTAINS[c] %@", searchText)
        var predicates = [or1, or2]
        
        if self.searchDict["charter"]! {
                predicates.append(NSPredicate(format: "charter = 'Yes'"))
        }
        
        if self.searchDict["magnet"]! {
            predicates.append(NSPredicate(format: "magnet = 'Yes'"))
        }
        
        if self.searchDict["title1"]! {
            predicates.append(NSPredicate(format: "title1 = 'Yes'"))
        }
        
        let predicate = NSCompoundPredicate(orPredicateWithSubpredicates: predicates)
        let results = schoolData!.filter(predicate)
        for result in results {
            filteredResults.append(result)
        }
        self.tableView.reloadData()
    }
    
    func presentFilterOptions(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "filterSegue", sender: self)
    }
}
