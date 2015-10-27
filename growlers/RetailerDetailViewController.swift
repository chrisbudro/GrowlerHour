//
//  RetailerDetailViewController.swift
//  growlers
//
//  Created by Chris Budro on 9/28/15.
//  Copyright © 2015 chrisbudro. All rights reserved.
//

import Foundation

class RetailerDetailViewController: BaseDetailViewController {
  
  //MARK: Properties
  var retailer: Retailer?
  
  //MARK: Life Cycle Methods
  override func viewDidLoad() {
    super.viewDidLoad()
    title = retailer?.retailerName
  }
  
  //MARK: Helper Methods
  override func queryForTaps() {
    if let
      retailer = retailer,
      queryManager = queryManager {
        activityIndicator.startAnimating()
        queryManager.tapsForObject(retailer, ofType: .Retailer) { (taps, error) in
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