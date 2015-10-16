//
//  BreweryDetailTableViewController.swift
//  growlers
//
//  Created by Chris Budro on 9/8/15.
//  Copyright (c) 2015 chrisbudro. All rights reserved.
//

import UIKit
import Parse

class BreweryDetailTableViewController: BaseTableViewController {
  
  var brewery: Brewery?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = brewery?.breweryName
    //TODO: Fix dangling pointers on brewery.taps and replace queryForTaps() with fetchTaps()
    queryForTaps()

    cellReuseIdentifier = kTapCellReuseIdentifier
    tableView.registerNib(UINib(nibName: kTapNibName, bundle: nil), forCellReuseIdentifier: cellReuseIdentifier)
    
    dataSource = BaseDataSource(cellReuseIdentifier: cellReuseIdentifier, configureCell: configureCell)
    tableView.dataSource = dataSource
  }
  
  func fetchTaps() {
    if let brewery = brewery {
      PFObject.fetchAllIfNeededInBackground(brewery.taps) { (taps, error) in
        if let error = error {
          let alert = ErrorAlertController.alertControllerWithError(error);
          self.presentViewController(alert, animated: true, completion: nil);
        } else if let taps = taps as? [Tap] {
          self.dataSource?.updateObjectsWithArray(taps)
          self.tableView.reloadData()
        }
      }
    }
  }
  
  func queryForTaps() {
    activityIndicator.startAnimating()
    if let brewery = brewery {
      QueryManager.shared.tapsForObject(brewery, ofType: .Brewery) { (taps, error) -> Void in
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

extension BreweryDetailTableViewController {

}
