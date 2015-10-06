//
//  StyleFilterTableViewController.swift
//  growlers
//
//  Created by Chris Budro on 9/8/15.
//  Copyright (c) 2015 chrisbudro. All rights reserved.
//

import UIKit

class StyleFilterTableViewController: BaseFilterTableViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "Choose Styles"
    CellReuseIdentifier = kStyleCellReuseIdentifier
    tableView.registerNib(UINib(nibName: kBeerStyleNibName, bundle: nil), forCellReuseIdentifier: CellReuseIdentifier)
    
    updateBrowseList()
  }
  
  //MARK: Table View Data source
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = super.tableView(tableView, cellForRowAtIndexPath: indexPath)
    let beerStyle = browseList[indexPath.row] as! BeerStyle
    
    cell.accessoryType = isSelected(beerStyle) ? .Checkmark : .None
    
    return cell
  }

  //MARK: Table View Delegate
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let beerStyle = browseList[indexPath.row] as! BeerStyle
    if let queryManager = queryManager {
      isSelected(beerStyle) ? queryManager.filter.removeBeerStyle(beerStyle) : queryManager.filter.addBeerStyle(beerStyle)
      let cell = tableView.cellForRowAtIndexPath(indexPath)
      cell?.accessoryType = isSelected(beerStyle) ? .Checkmark : .None
      delegate?.filterWasUpdated(queryManager.filter)
    }
  }
  
  func isSelected(beerStyle: BeerStyle) -> Bool {
    return queryManager?.filter.categoryIds.indexOf(beerStyle.categoryId) != nil ? true : false
  }
}
