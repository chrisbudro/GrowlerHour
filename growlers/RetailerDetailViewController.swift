//
//  RetailerDetailViewController.swift
//  growlers
//
//  Created by Chris Budro on 9/28/15.
//  Copyright © 2015 chrisbudro. All rights reserved.
//

import Foundation

class RetailerDetailViewController: BaseTableViewController {
  
  var retailer: Retailer?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = retailer?.retailerName
    
    queryForTaps()
    
    cellReuseIdentifier = kTapCellReuseIdentifier
    tableView.registerNib(UINib(nibName: kTapNibName, bundle: nil), forCellReuseIdentifier: cellReuseIdentifier)
    
    dataSource = BaseDataSource(cellReuseIdentifier: cellReuseIdentifier, configureCell: configureCell)
    tableView.dataSource = dataSource
  }
  
  func queryForTaps() {
    if let retailer = retailer {
      activityIndicator.startAnimating()
      QueryManager.shared.tapsForObject(retailer, ofType: .Retailer) { (taps, error) in
        if let error = error {
          let alert = ErrorAlertController.alertControllerWithError(error)
          self.presentViewController(alert, animated: true, completion: nil)
        } else if let taps = taps {
          self.dataSource?.updateObjectsWithArray(taps)
          self.tableView.reloadData()
        }
        self.activityIndicator.stopAnimating()
      }
    }
  }
}