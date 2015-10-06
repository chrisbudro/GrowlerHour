//
//  BreweryBrowseTableViewController.swift
//  growlers
//
//  Created by Chris Budro on 9/8/15.
//  Copyright (c) 2015 chrisbudro. All rights reserved.
//

import UIKit

class BreweryBrowseTableViewController: BaseTableViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "Breweries"
    
    CellReuseIdentifier = kBreweryCellReuseIdentifier
    tableView.registerNib(UINib(nibName: kBreweryNibName, bundle: nil), forCellReuseIdentifier: CellReuseIdentifier)
    
    queryManager = GenericQueryManager(type: .Brewery)
    updateBrowseList()
  }
}

//MARK: Table View Delegate
extension BreweryBrowseTableViewController {
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    
    let vc = BreweryDetailTableViewController(style: .Plain)
    if let brewery = browseList[indexPath.row] as? Brewery {
      vc.brewery = brewery
    }
    navigationController?.pushViewController(vc, animated: true)
  }
}
