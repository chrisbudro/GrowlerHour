//
//  StyleFilterController.swift
//  growlers
//
//  Created by Chris Budro on 5/1/15.
//  Copyright (c) 2015 chrisbudro. All rights reserved.
//

import UIKit
import Parse

class StyleFilterController: UITableViewController {

    var beerCategories: NSMutableOrderedSet = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var query = PFQuery(className: "Tap")
        query.limit = 1000
        query.orderByAscending("category")
        query.findObjectsInBackgroundWithBlock { (objects: [AnyObject]?, error: NSError?) -> Void in
            if error == nil {
                
                if let objects = objects as? [PFObject] {
                    for object in objects {
                        var beerCategory = object["category"] as! String
                        self.beerCategories.addObject(beerCategory)
                    }
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.tableView.reloadData()
                    })
                }
            }
        }
        
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return beerCategories.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
        
        cell.textLabel!.textColor = UIColor.darkGrayColor()
        cell.textLabel!.text = beerCategories[indexPath.row] as? String
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let cell = tableView.cellForRowAtIndexPath(indexPath) {
        
            if ( cell.accessoryType == .None ) {
                cell.accessoryType = .Checkmark
            } else {
                cell.accessoryType = .None
                
            }
        }
        

        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
    }
    
    // MARK: - Navigation
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "showTaps") {
            if let
                vc = segue.destinationViewController as? TapListController,
                indexPath = sender as? NSIndexPath,
                category = beerCategories[indexPath.row] as? String
            {
                vc.queryIdentifier = category
                vc.queryKey = "category"
            }
        }
        
    }
    
    
}
