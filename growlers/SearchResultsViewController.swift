//
//  SearchResultsViewController.swift
//  growlers
//
//  Created by Chris Budro on 10/1/15.
//  Copyright © 2015 chrisbudro. All rights reserved.
//

import Foundation

class ResultsViewController: BaseTableViewController {
  
  let kFilterHeaderHeight: CGFloat = 50
  
  //MARK: Properties
  var filterHeader: UIView?

  var textCleared = false
  let searchBar = UISearchBar()
  
  //MARK: Life Cycle Methods
  
  deinit {
    NSNotificationCenter.defaultCenter().removeObserver(self)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    
    let filterButton = UIBarButtonItem(image: UIImage(named: "sliders"), style: .Plain, target: self, action: "showFiltersWasPressed")
    navigationItem.rightBarButtonItem = filterButton
    
    queryManager = GenericQueryManager(type: .Tap)
    queryManager?.locationFilterMethod = .CurrentLocation
    
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "locationWasUpdated:", name: kLocationUpdatedNotification, object: nil)

    CellReuseIdentifier = kTapCellReuseIdentifier
    tableView.registerNib(UINib(nibName: kTapNibName, bundle: nil), forCellReuseIdentifier: CellReuseIdentifier)

    tableView.registerNib(UINib(nibName: kFilterHeaderNibName, bundle: nil), forCellReuseIdentifier: kFilterHeaderCellReuseIdentifier)
    
    updateBrowseList()
    
    searchBar.delegate = self
    searchBar.placeholder = "Search For Available Beers"
    navigationItem.titleView = searchBar
  }
  
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    tableView.estimatedRowHeight = kEstimatedCellHeight
    tableView.rowHeight = UITableViewAutomaticDimension
    
  }
  
  //MARK: Helper Methods

  override func updateBrowseList() {
    self.textCleared = false
    if !self.browseList.isEmpty {
      self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), atScrollPosition: .None, animated: false)
    }
    super.updateBrowseList()
  }

  func clearFilterWasPressed() {
    queryManager?.filter.clearFilter()
  }
  
  func showFiltersWasPressed() {
    let filterViewNavController = storyboard?.instantiateViewControllerWithIdentifier("FilterViewNavController") as! UINavigationController
    let filterViewController = filterViewNavController.viewControllers.first as! FilterViewController
    filterViewController.filter = queryManager?.filter
    filterViewController.delegate = self
    presentViewController(filterViewNavController, animated: true, completion: nil)
  }
  
  func locationWasUpdated(notification: NSNotification) {
    switch queryManager!.locationFilterMethod {
    case .CurrentLocation:
     let userInfo = notification.userInfo!
      let _ = userInfo[kNewLocationKey]
      updateBrowseList()
    default:
      break
    }
  }
}

// MARK: Search Bar Delegate
extension ResultsViewController: UISearchBarDelegate {
  
  func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
    searchBar.showsCancelButton = true
  }
  
  func searchBarTextDidEndEditing(searchBar: UISearchBar) {
    searchBar.showsCancelButton = false
  }
  
  func searchBarSearchButtonClicked(searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
    queryManager?.filter.searchTerm = searchBar.text
    updateBrowseList()
  }
  
  func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
    if (searchText.isEmpty && textCleared == false) {
      textCleared = true
      queryManager?.filter.searchTerm = nil
      updateBrowseList()
    }
  }
  
  func searchBarCancelButtonClicked(searchBar: UISearchBar) {
    searchBar.text = ""
    searchBar.resignFirstResponder()
  }
}

//MARK: Table View Delegate
extension ResultsViewController {
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    searchBar.resignFirstResponder()
    
    let tap = browseList[indexPath.row] as! Tap
    let vc = TapDetailViewController()
    vc.tap = tap
    navigationController?.pushViewController(vc, animated: true)
  }
}

extension ResultsViewController: FilterDelegate {
  func filterWasUpdated(filter: Filter) {
    queryManager?.filter = filter
    queryManager?.filter.isDirty = false
    updateBrowseList()
  }
}