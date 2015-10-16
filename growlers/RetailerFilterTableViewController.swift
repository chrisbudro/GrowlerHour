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
    cellReuseIdentifier = kRetailerCellReuseIdentifier
    tableView.registerNib(UINib(nibName: kRetailerNibName, bundle: nil), forCellReuseIdentifier: cellReuseIdentifier)
    
    dataSource = TableViewDataSource(cellReuseIdentifier: cellReuseIdentifier, configureCell: configureCell)
    tableView.dataSource = dataSource
    
    updateBrowseList()
  }

  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    if let
      retailer = dataSource?.objectAtIndexPath(indexPath) as? Retailer,
      queryManager = queryManager {
        isSelected(retailer) ? queryManager.filter.removeRetailer(retailer) : queryManager.filter.addRetailer(retailer)
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell?.accessoryType = isSelected(retailer) ? .Checkmark : .None
        delegate?.filterWasUpdated(queryManager.filter)
    }
  }
}
