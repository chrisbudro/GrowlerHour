//
//  LocationResultsTableViewController.swift
//  growlers
//
//  Created by Chris Budro on 10/4/15.
//  Copyright © 2015 chrisbudro. All rights reserved.
//

import UIKit

protocol LocationPickerDelegate: class {
  func customLocationWasPicked(locationDetails: LocationDetails)
  func currentLocationWasPicked()
}

final class LocationSearchTableViewController: UITableViewController {
  
  //MARK: Properties
  let resultsViewController = UITableViewController(style: .Plain)
  var searchController: UISearchController!
  weak var delegate: LocationPickerDelegate?
  
  var searchResults = [GMSAutocompletePrediction]()
  
  //MARK: Life Cycle Methods
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Location"
    
    tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    resultsViewController.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    
    searchController = UISearchController(searchResultsController: resultsViewController)
    resultsViewController.tableView.frame = tableView.frame
    resultsViewController.tableView.dataSource = self
    resultsViewController.tableView.delegate = self
    searchController.searchResultsUpdater = self
    tableView.tableHeaderView = searchController.searchBar
  }
  
  // MARK: Table view data source
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if tableView == self.tableView {
      return 1
    } else if tableView == self.resultsViewController.tableView {
      return searchResults.count
    }
    return 0
  }

  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
  let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
    if tableView == self.tableView {
      cell.textLabel!.text = "Current Location"
    } else if tableView == resultsViewController.tableView {
      let prediction = searchResults[indexPath.row]
      cell.textLabel!.text = prediction.attributedFullText.string
    }
  return cell
  }

  //MARK: Table View Delegate
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    if tableView == self.tableView {
      self.delegate?.currentLocationWasPicked()
      self.navigationController?.popViewControllerAnimated(true)
    } else if tableView == resultsViewController.tableView {
      let prediction = searchResults[indexPath.row]
      GooglePlacesService.detailsForPrediction(prediction) { (locationDetails, error) -> Void in
        if let error = error {
          let alert = ErrorAlertController.alertControllerWithError(error)
          self.resultsViewController.presentViewController(alert, animated: true, completion: nil)
        } else if let locationDetails = locationDetails {
          self.delegate?.customLocationWasPicked(locationDetails)
          self.dismissViewControllerAnimated(true) {
            self.navigationController?.popViewControllerAnimated(true)
          }
        }
      }
    }
  }
}

//MARK: Search Results Updating
extension LocationSearchTableViewController: UISearchResultsUpdating {
  func updateSearchResultsForSearchController(searchController: UISearchController) {
    GooglePlacesService.autocompleteResultsFromSearchTerm(searchController.searchBar.text) { (predictions, error) -> Void in
      if let _ = error {
        //TODO: Handle error
      } else if let predictions = predictions {
        self.searchResults = predictions
        self.resultsViewController.tableView.reloadData()
      }
    }
  }
}
