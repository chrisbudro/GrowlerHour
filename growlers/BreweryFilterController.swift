//
//  BreweryFilterController.swift
//  growlers
//
//  Created by Chris Budro on 5/1/15.
//  Copyright (c) 2015 chrisbudro. All rights reserved.
//

import UIKit
import Parse


class BreweryFilterController: UITableViewController {

    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var breweriesList: [PFObject] = []
    var breweryFilters: [Int] {
        get {
            return QueryManager.shared.filters.breweryIds
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var searchResultsViewController = UITableViewController()
        var searchController = UISearchController(searchResultsController: searchResultsViewController)

        
        

    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return breweriesList.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! BreweryViewCell
        
        

        let brewery = breweriesList[indexPath.row]
        let breweryId = brewery["breweryId"] as? Int
        if let breweryName = brewery["breweryName"] as? String {
            cell.breweryNameLabel.text = breweryName
        }
        if let
            city = brewery["city"] as? String,
            state = brewery["state"] as? String
        {
            cell.homeTownLabel.text = "\(city), \(state)"
        }
//            if let
//                icon = brewery["imageUrl"] as? String,
//                iconUrl = NSURL(string: icon)
//            {
//                let session = NSURLSession.sharedSession()
//                let task : NSURLSessionDownloadTask = session.downloadTaskWithURL(iconUrl, completionHandler: { (imageUrl, response, error) -> Void in
//                    if (error == nil) {
//                        let data = NSData(contentsOfURL: imageUrl)
//                        
//                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                            cell.logoImageView.image = UIImage(data: data!)
//                        })
//                    } else {
//                        println(error)
//                    }
//                })
//                task.resume()
//            } else {
//                cell.logoImageView.image = UIImage.imageWithColor(named: "growlerIconLight", withColor: UIColor.redColor())
//            }
        
        if (find(breweryFilters, breweryId!) != nil) {
            cell.accessoryType = .Checkmark
        } else {
            cell.accessoryType = .None
        }
    
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        let brewery = breweriesList[indexPath.row]
        let breweryId = brewery["breweryId"] as! Int
//        if (find(breweryFilters, breweryId) == nil) {
//            QueryManager.shared.addFilter(breweryId, type: .Brewery)
//        } else {
//            QueryManager.shared.removeFilter(breweryId, type: .Brewery)
//        }
        
        println(QueryManager.shared.filters.breweryIds)
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        tableView.reloadData()
    }
    
    
    @IBAction func cancelWasPressed(sender: UIBarButtonItem) {
        navigationController?.popViewControllerAnimated(true)
    }

    
    @IBAction func doneWasPressed(sender: UIBarButtonItem) {
        navigationController?.popViewControllerAnimated(true)
    }
    
}
