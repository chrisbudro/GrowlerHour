//
//  NearbyBrowseViewController.swift
//  growlers
//
//  Created by Chris Budro on 10/3/15.
//  Copyright © 2015 chrisbudro. All rights reserved.
//

import UIKit

class NearbyBrowseViewController: UITableViewController {
  
  var queryManager = GenericQueryManager(type: .Retailer)
  var retailerList = [Retailer]()
  let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.registerNib(UINib(nibName: kTapNibName, bundle: nil), forCellReuseIdentifier: kTapCellReuseIdentifier)
    
    tableView.estimatedRowHeight = kEstimatedCellHeight
    tableView.rowHeight = UITableViewAutomaticDimension
    
    updateRetailerList()
  }
  
  func updateRetailerList() {
    retailerList = []
    tableView.reloadData()
    activityIndicator.center = tableView.center
    tableView.addSubview(activityIndicator)
    activityIndicator.startAnimating()
    queryManager.results { (results, error) in
      if let error = error {
        let alert = ErrorAlertController.alertControllerWithError(error)
        self.presentViewController(alert, animated: true, completion: nil)
      } else if let results = results as? [Retailer] {
        self.retailerList = results
        
        self.tableView.reloadData()
      }
      self.activityIndicator.stopAnimating()
    }
  }
  
  
  
  // MARK: - Table view data source
  
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return retailerList.count
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let retailer = retailerList[section]
//    return retailer.taps.count
    return 0
  }
  
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(kTapCellReuseIdentifier, forIndexPath: indexPath) as! BeerViewCell
//    let retailer = retailerList[indexPath.section]
//    let tap = retailer.taps[indexPath.row]
//    if tap.isDataAvailable() {
//      cell.configureCellForObject(tap)
//    } else {
//      tap.fetchIfNeededInBackgroundWithBlock { (tap, error) in
//        if let error = error {
//          print("error: \(error.localizedDescription)")
//        } else if let tap = tap as? Tap {
//          cell.configureCellForObject(tap)
//        }
//      }
//    }
    return cell
  }
  
  override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    let retailer = retailerList[section]
    return retailer.retailerName
  }
  
}
