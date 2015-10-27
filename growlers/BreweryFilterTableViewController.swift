//
//  BreweryFilterTableViewController.swift
//  growlers
//
//  Created by Chris Budro on 9/8/15.
//  Copyright (c) 2015 chrisbudro. All rights reserved.
//

import UIKit

final class BreweryFilterTableViewController: BaseFilterTableViewController {
  
  //MARK: Life Cycle Methods
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "Choose Breweries"
    cellReuseIdentifier = kBreweryCellReuseIdentifier
    tableView.registerNib(UINib(nibName: kBreweryNibName, bundle: nil), forCellReuseIdentifier: cellReuseIdentifier)

    dataSource = TableViewDataSource(cellReuseIdentifier: kBreweryCellReuseIdentifier, configureCell: configureCell)
    tableView.dataSource = dataSource
    updateBrowseList()
  }

  //MARK: Table View Delegate
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    if let
      brewery = dataSource?.objectAtIndexPath(indexPath) as? Brewery,
      queryManager = queryManager {
        isSelected(brewery) ? queryManager.filter.removeBrewery(brewery) : queryManager.filter.addBrewery(brewery)
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell?.accessoryType = isSelected(brewery) ? .Checkmark : .None
        delegate?.filterWasUpdated(queryManager.filter)
    }
  }
}
