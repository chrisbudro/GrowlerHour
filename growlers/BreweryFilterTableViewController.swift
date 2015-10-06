//
//  BreweryFilterTableViewController.swift
//  growlers
//
//  Created by Chris Budro on 9/8/15.
//  Copyright (c) 2015 chrisbudro. All rights reserved.
//

import UIKit

class BreweryFilterTableViewController: BaseFilterTableViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "Choose Breweries"
    CellReuseIdentifier = kBreweryCellReuseIdentifier
    tableView.registerNib(UINib(nibName: kBreweryNibName, bundle: nil), forCellReuseIdentifier: CellReuseIdentifier)
    
    updateBrowseList()
  }
  
  //MARK: Table View Data Source
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = super.tableView(tableView, cellForRowAtIndexPath: indexPath)
    let brewery = browseList[indexPath.row] as! Brewery
    
    cell.accessoryType = isSelected(brewery) ? .Checkmark : .None
    
    return cell
  }

//MARK: Table View Delegate
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let brewery = browseList[indexPath.row] as! Brewery
    if let queryManager = queryManager {
      isSelected(brewery) ? queryManager.filter.removeBrewery(brewery) : queryManager.filter.addBrewery(brewery)
      let cell = tableView.cellForRowAtIndexPath(indexPath)
      cell?.accessoryType = isSelected(brewery) ? .Checkmark : .None
      delegate?.filterWasUpdated(queryManager.filter)
    }
  }
  
  func isSelected(brewery: Brewery) -> Bool {
    return queryManager?.filter.breweryIds.indexOf(brewery.breweryId) != nil ? true : false
  }
}
