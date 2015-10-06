//
//  RetailerFilterTableViewController.swift
//  growlers
//
//  Created by Chris Budro on 9/8/15.
//  Copyright (c) 2015 chrisbudro. All rights reserved.
//

import UIKit

class RetailerFilterTableViewController: BaseFilterTableViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "Choose Retailers"
    CellReuseIdentifier = kRetailerCellReuseIdentifier
    tableView.registerNib(UINib(nibName: kRetailerNibName, bundle: nil), forCellReuseIdentifier: CellReuseIdentifier)
    
    updateBrowseList()
  }
  
  //MARK: Table View Delegate
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = super.tableView(tableView, cellForRowAtIndexPath: indexPath)
    let retailer = browseList[indexPath.row] as! Retailer
    
    cell.accessoryType = isSelected(retailer) ? .Checkmark : .None
    
    return cell
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let retailer = browseList[indexPath.row] as! Retailer
    if let queryManager = queryManager {
      isSelected(retailer) ? queryManager.filter.removeRetailer(retailer) : queryManager.filter.addRetailer(retailer)
      let cell = tableView.cellForRowAtIndexPath(indexPath)
      cell?.accessoryType = isSelected(retailer) ? .Checkmark : .None
      delegate?.filterWasUpdated(queryManager.filter)
    }
  }
  
  //MARK: Helper Methods

  func isSelected(retailer: Retailer) -> Bool {
    return queryManager?.filter.retailerIds.indexOf(retailer.retailerId) != nil ? true : false
  }
}
