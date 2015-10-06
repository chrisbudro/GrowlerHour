//
//  RetailerFilterController.swift
//  growlers
//
//  Created by Chris Budro on 5/1/15.
//  Copyright (c) 2015 chrisbudro. All rights reserved.
//

import UIKit
import Parse

class RetailerFilterController: UITableViewController {

    var retailers: [PFObject] {
        return QueryManager.shared.retailerList
    }
    var retailerFilters: [String] {
        return QueryManager.shared.filters.retailerIds
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        QueryManager.shared.makeRetailerQuery { () -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.tableView.reloadData()
            })
        }
        
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return retailers.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! RetailerViewCell
        
        let retailer = retailers[indexPath.row]
        cell.retailerNameLabel.text = retailer["retailerName"] as? String
        let StreetAddress = retailer["streetAddress"] as? String
        let city = (retailer["city"] as! String) + ", " + (retailer["state"] as! String)
        cell.retailerAddressLabel.text = "\(StreetAddress!), \(city)"
        
        let tapCount = QueryManager.shared.getTapCount(retailer)
        
        cell.numberOfTapsLabel.text = "\(tapCount) Beers on Tap"


        
        let retailerId = retailer["placeId"] as! String
        
        if (find(retailerFilters, retailerId) != nil) {
            cell.accessoryType = .Checkmark
        } else {
            cell.accessoryType = .None
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let retailer = retailers[indexPath.row]
        if let placeId = retailer["placeId"] as? String {
//            if (find(retailerFilters, placeId) == nil) {
//                QueryManager.shared.addFilter(placeId, type: .Retailer)
//            } else {
//                QueryManager.shared.removeFilter(placeId, type: .Retailer)
//            }
        }
        tableView.reloadData()
    }
    
    
    // MARK: Buttons
    
    @IBAction func doneWasPressed(sender: UIBarButtonItem) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func cancelWasPressed(sender: UIBarButtonItem) {
        navigationController?.popViewControllerAnimated(true)
        
    }

}
