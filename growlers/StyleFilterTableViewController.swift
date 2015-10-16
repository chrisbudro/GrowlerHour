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
    cellReuseIdentifier = kStyleCellReuseIdentifier
    tableView.registerNib(UINib(nibName: kBeerStyleNibName, bundle: nil), forCellReuseIdentifier: cellReuseIdentifier)
    
    dataSource = TableViewDataSource(cellReuseIdentifier: kStyleCellReuseIdentifier, configureCell: configureCell)
    tableView.dataSource = dataSource
    updateBrowseList()
  }

  //MARK: Table View Delegate
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    if let
      beerStyle = dataSource?.objectAtIndexPath(indexPath) as? BeerStyle,
      queryManager = queryManager {
        isSelected(beerStyle) ? queryManager.filter.removeBeerStyle(beerStyle) : queryManager.filter.addBeerStyle(beerStyle)
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell?.accessoryType = isSelected(beerStyle) ? .Checkmark : .None
        delegate?.filterWasUpdated(queryManager.filter)
    }
  }
}
