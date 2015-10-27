//
//  BreweryBrowseTableViewController.swift
//  growlers
//
//  Created by Chris Budro on 9/8/15.
//  Copyright (c) 2015 chrisbudro. All rights reserved.
//

import UIKit

class BreweryBrowseTableViewController: BaseBrowseViewController {

  //MARK: Life Cycle Methods
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "Breweries"
    
    cellReuseIdentifier = kBreweryCellReuseIdentifier
    tableView.registerNib(UINib(nibName: kBreweryNibName, bundle: nil), forCellReuseIdentifier: cellReuseIdentifier)

    dataSource = TableViewDataSource(cellReuseIdentifier:cellReuseIdentifier, configureCell: configureCell)
    tableView.dataSource = dataSource
    
    updateBrowseList()
  }
}

//MARK: Table View Delegate
extension BreweryBrowseTableViewController {
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    
    let vc = BreweryDetailTableViewController(style: .Plain)
    if let brewery = dataSource?.objectAtIndexPath(indexPath) as? Brewery {
      vc.brewery = brewery
      if let queryManager = queryManager {
        let breweryQueryManager = QueryManager(type: .Tap, filter: queryManager.filter)
        vc.queryManager = breweryQueryManager
      }
    }
    navigationController?.pushViewController(vc, animated: true)
  }
}
