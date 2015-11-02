//
//  RetailerBrowseTableViewController.swift
//  growlers
//
//  Created by Chris Budro on 9/8/15.
//  Copyright (c) 2015 chrisbudro. All rights reserved.
//

import UIKit

class RetailerBrowseTableViewController: BaseBrowseViewController {
  
  //MARK: Life Cycle Methods
  override func viewDidLoad() {
    super.viewDidLoad()
    let mapButton = UIBarButtonItem(title: "Map", style: .Plain, target: self, action: "mapButtonWasPressed")
    navigationItem.leftBarButtonItem = mapButton
    
    title = "Retailers"
    
    cellReuseIdentifier = kRetailerCellReuseIdentifier
    tableView.registerNib(UINib(nibName: kRetailerNibName, bundle: nil), forCellReuseIdentifier: cellReuseIdentifier)
    
    dataSource = TableViewDataSource(cellReuseIdentifier: cellReuseIdentifier, configureCell: configureCell)
    tableView.dataSource = dataSource

    updateBrowseList()
  }
  
  func mapButtonWasPressed() {
    let mapViewController = MapViewController()
    if let retailers = dataSource?.objects as? [Retailer] {
      mapViewController.markers = retailers.map() { $0.mapMarker }
      navigationController?.pushViewController(mapViewController, animated: true)
    }
  }
  
  //MARK: Table View Delegate
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    if let retailer = dataSource?.objectAtIndexPath(indexPath) as? Retailer {
      let vc = RetailerDetailViewController()
      vc.retailer = retailer
      if let queryManager = queryManager {
        let retailerQueryManager = QueryManager(type: .Tap, filter: queryManager.filter)
        vc.queryManager = retailerQueryManager
      }
      navigationController?.pushViewController(vc, animated: true)
    }
  }
}
