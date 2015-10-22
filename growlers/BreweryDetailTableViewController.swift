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
  
  var brewery: Brewery?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = brewery?.breweryName
    
//    cellReuseIdentifier = kTapCellReuseIdentifier
//    tableView.registerNib(UINib(nibName: kTapNibName, bundle: nil), forCellReuseIdentifier: cellReuseIdentifier)
//    
//    queryManager = GenericQueryManager(type: .Brewery)
//    
//    dataSource = TableViewDataSource(cellReuseIdentifier: cellReuseIdentifier, configureCell: configureCell)
//    tableView.dataSource = dataSource
//    
//    queryForTaps()
  }
  
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
