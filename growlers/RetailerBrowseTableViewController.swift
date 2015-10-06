//
//  RetailerBrowseTableViewController.swift
//  growlers
//
//  Created by Chris Budro on 9/8/15.
//  Copyright (c) 2015 chrisbudro. All rights reserved.
//

import UIKit

class RetailerBrowseTableViewController: BaseTableViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "Retailers"
    
    CellReuseIdentifier = kRetailerCellReuseIdentifier
    tableView.registerNib(UINib(nibName: kRetailerNibName, bundle: nil), forCellReuseIdentifier: CellReuseIdentifier)

    queryManager = GenericQueryManager(type: .Retailer)
    updateBrowseList()
  }
  
  //MARK: Table View Delegate
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    if let retailer = browseList[indexPath.row] as? Retailer {
      let vc = RetailerDetailViewController()
      vc.retailer = retailer
      navigationController?.pushViewController(vc, animated: true)
    }
  }
}
