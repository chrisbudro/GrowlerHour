//
//  RetailerBrowseTableViewController.swift
//  growlers
//
//  Created by Chris Budro on 9/8/15.
//  Copyright (c) 2015 chrisbudro. All rights reserved.
//

import UIKit

class RetailerBrowseTableViewController: BaseBrowseViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "Retailers"
    
    cellReuseIdentifier = kRetailerCellReuseIdentifier
    tableView.registerNib(UINib(nibName: kRetailerNibName, bundle: nil), forCellReuseIdentifier: cellReuseIdentifier)
    
    dataSource = TableViewDataSource(cellReuseIdentifier: cellReuseIdentifier, configureCell: configureCell)
    tableView.dataSource = dataSource

//    queryManager = GenericQueryManager(type: .Retailer)
    updateBrowseList()
  }
  
  //MARK: Table View Delegate
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    if let retailer = dataSource?.objectAtIndexPath(indexPath) as? Retailer {
      let vc = RetailerDetailViewController()
      vc.retailer = retailer
      navigationController?.pushViewController(vc, animated: true)
    }
  }
}
