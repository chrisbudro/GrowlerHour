//
//  StyleBrowseTableViewController.swift
//  growlers
//
//  Created by Chris Budro on 9/8/15.
//  Copyright (c) 2015 chrisbudro. All rights reserved.
//

import UIKit

class StyleBrowseTableViewController: BaseBrowseViewController {
  
  //MARK: Life Cycle Methods
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Styles"
    
    cellReuseIdentifier = kStyleCellReuseIdentifier
    tableView.registerNib(UINib(nibName: kBeerStyleNibName, bundle: nil), forCellReuseIdentifier: cellReuseIdentifier)
    
    dataSource = TableViewDataSource(cellReuseIdentifier: cellReuseIdentifier, configureCell: configureCell)
    tableView.dataSource = dataSource
    
    updateBrowseList()
  }
}

//MARK: Table View Delegate
extension StyleBrowseTableViewController {
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let vc = BeerStyleDetailViewController(style: .Plain)
    if let beerStyle = dataSource?.objectAtIndexPath(indexPath) as? BeerStyle {
      vc.beerStyle = beerStyle
      if let queryManager = queryManager {
        let styleQueryManager = GenericQueryManager(type: .Tap, filter: queryManager.filter)
        vc.queryManager = styleQueryManager
      }
    }
    navigationController?.pushViewController(vc, animated: true)
  }
  
  override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    //TODO: Not a valid solution.  Need to solve UITableViewAutomaticDimension bug with insertRowAtIndexPaths
    return 60
  }
}


