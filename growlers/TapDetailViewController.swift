//
//  TapDetailViewController.swift
//  growlers
//
//  Created by Chris Budro on 5/17/15.
//  Copyright (c) 2015 chrisbudro. All rights reserved.
//

import UIKit
import Parse

class TapDetailViewController: UITableViewController {
  
  //MARK: Constants
  let kCellReuseIdentifier = "Cell"
  let kSectionHeaderHeight: CGFloat = 25
  let kTapSection = 0
  let kBrewerySection = 1
  let kRetailerSection = 2
  
  //MARK: Properties
  var retailerList: [Retailer] = []
  var tap: Tap?
  var brewery: Brewery?
  
  var filter: Filter!
  
  //MARK: Life Cycle Methods
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.registerNib(UINib(nibName: kRetailerNibName, bundle: nil), forCellReuseIdentifier: kRetailerCellReuseIdentifier)
    tableView.registerNib(UINib(nibName: kTapNibName, bundle: nil), forCellReuseIdentifier: kTapCellReuseIdentifier)
    tableView.registerNib(UINib(nibName: kBreweryNibName, bundle: nil), forCellReuseIdentifier: kBreweryCellReuseIdentifier)
    
    tableView.separatorStyle = .None
    tableView.estimatedRowHeight = kEstimatedCellHeight
    tableView.rowHeight = UITableViewAutomaticDimension
    
    populateDataSource()
  }
  
  //MARK: Helper Methods
  func populateDataSource() {
    let activityIndicator = UIActivityIndicatorView(frame: CGRectMake(view.frame.width / 2, view.frame.height / 2, 15, 15))
    view.addSubview(activityIndicator)
    
    let loadGroup = dispatch_group_create()
    var loadError: NSError?
    
    if let tap = tap {
      activityIndicator.startAnimating()
      dispatch_group_enter(loadGroup)
      tap.brewery.fetchIfNeededInBackgroundWithBlock { (brewery, error) -> Void in
        if let error = error {
          loadError = error
        } else if let brewery = brewery as? Brewery {
          self.brewery = brewery
        }
        dispatch_group_leave(loadGroup)
      }
      dispatch_group_enter(loadGroup)
      
      PFObject.fetchAllIfNeededInBackground(tap.retailers) { (retailers, error) -> Void in
        if let error = error {
          loadError = error
        } else if let retailers = retailers as? [Retailer] {
          
          LocationService.shared.selectedGeoPointIfAvailable { (locationGeoPoint, error) -> Void in
            if let error = error {
              loadError = error
            } else if let locationGeoPoint = locationGeoPoint {
              self.retailerList = retailers.sort { (firstRetailer, secondRetailer) -> Bool in
                let firstDistance = firstRetailer.coordinates.distanceInMilesTo(locationGeoPoint)
                let secondDistance = secondRetailer.coordinates.distanceInMilesTo(locationGeoPoint)
                
                return firstDistance < secondDistance
              }
            }
          }
          dispatch_group_leave(loadGroup)
        }
      }
      
      dispatch_group_notify(loadGroup, dispatch_get_main_queue()) {
        if let loadError = loadError {
          let alert = ErrorAlertController.alertControllerWithError(loadError)
          self.presentViewController(alert, animated: true, completion: nil)
        } else {
          self.tableView.reloadData()
        }
        activityIndicator.stopAnimating()
      }
    }
  }
  
  // MARK: Table view data source
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    var numberOfSections = 0
    
    if tap != nil {
      numberOfSections++
    }
    
    if brewery != nil {
      numberOfSections++
    }
    
    if !retailerList.isEmpty {
      numberOfSections++
    }
    return numberOfSections
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if (section == kRetailerSection) {
      return retailerList.count
    }
    if (section == kBrewerySection) {
      if let _ = brewery {
        return 1
      } else {
        return 0
      }
    }
    return 1
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    if (indexPath.section == kRetailerSection) {
      let cell = tableView.dequeueReusableCellWithIdentifier(kRetailerCellReuseIdentifier, forIndexPath: indexPath) as! RetailerViewCell
      
      let retailer = retailerList[indexPath.row]
      cell.configureCellForObject(retailer)
      
      return cell
    } else if (indexPath.section == kTapSection) {
      let cell = tableView.dequeueReusableCellWithIdentifier(kTapCellReuseIdentifier, forIndexPath: indexPath) as! BeerViewCell
      cell.configureCellForObject(tap!)
      
      return cell
      
    } else {
      let cell = tableView.dequeueReusableCellWithIdentifier(kBreweryCellReuseIdentifier, forIndexPath: indexPath) as! BreweryViewCell
      
      cell.configureCellForObject(brewery!)
      return cell
    }
  }
  
  //MARK: Table View Delegate
  override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    if (section == kRetailerSection || section == kBrewerySection) {
      return kSectionHeaderHeight
    }
    return 0
  }
  
  override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    if (section == kBrewerySection) {
      return "Brewery"
    }
    else if (section == kRetailerSection) {
      return "Retailers"
    }
    return nil
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let queryManager = QueryManager(type: .Tap, filter: filter)
    
    if indexPath.section == kBrewerySection {
      let vc = BreweryDetailTableViewController()
      vc.brewery = brewery
      vc.queryManager = queryManager
      navigationController?.pushViewController(vc, animated: true)
    }
    else if indexPath.section == kRetailerSection {
      let vc = RetailerDetailViewController()
      vc.retailer = retailerList[indexPath.row]
      vc.queryManager = queryManager
      navigationController?.pushViewController(vc, animated: true)
    }
  }
}
