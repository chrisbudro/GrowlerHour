//
//  BaseDetailViewController.swift
//  growlers
//
//  Created by Chris Budro on 10/4/15.
//  Copyright © 2015 chrisbudro. All rights reserved.
//

import UIKit
import Parse

class BaseDetailViewController: BaseTableViewController {
  //MARK: Properties
  var parentObject: PFObject?

  //MARK: Life Cycle Methods
  override func viewDidLoad() {
    super.viewDidLoad()

    cellReuseIdentifier = kTapCellReuseIdentifier
    tableView.registerNib(UINib(nibName: kTapNibName, bundle: nil), forCellReuseIdentifier: cellReuseIdentifier)
    
    dataSource = TableViewDataSource(cellReuseIdentifier: cellReuseIdentifier, configureCell: configureCell)
    tableView.dataSource = dataSource
    
    queryForTaps()
  }

  //MARK: Helper Methods
  func queryForTaps() {}
}

//MARK: Table View Delegate
extension BaseDetailViewController {
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    if let tap = dataSource?.objectAtIndexPath(indexPath) as? Tap {
      let tapDetailVC = TapDetailViewController()
      tapDetailVC.tap = tap
      if let queryManager = queryManager {
        tapDetailVC.filter = queryManager.filter
      }
      navigationController?.pushViewController(tapDetailVC, animated: true)
    }
  }
}