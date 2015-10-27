//
//  BreweryDetailTableViewController.swift
//  growlers
//
//  Created by Chris Budro on 9/8/15.
//  Copyright (c) 2015 chrisbudro. All rights reserved.
//

import UIKit
import Parse

class BreweryDetailTableViewController: BaseDetailViewController {
  
  //MARK: Properties
  var brewery: Brewery?
  
  //MARK: Life Cycle Methods
  override func viewDidLoad() {
    super.viewDidLoad()
    title = brewery?.breweryName
  }
  
  //MARK: Helper Methods
  override func queryForTaps() {
    if let
      brewery = brewery,
      queryManager = queryManager {
        activityIndicator.startAnimating()
        queryManager.tapsForObject(brewery, ofType: .Brewery) { (taps, error) -> Void in
          if let error = error {
            let alert = ErrorAlertController.alertControllerWithError(error);
            self.presentViewController(alert, animated: true, completion: nil);
          } else if let taps = taps {
            self.dataSource?.updateObjectsWithArray(taps)
            self.tableView.reloadData()
          }
          self.activityIndicator.stopAnimating()
        }
    }
  }
}
