//
//  SearchResultsViewController.swift
//  growlers
//
//  Created by Chris Budro on 10/1/15.
//  Copyright © 2015 chrisbudro. All rights reserved.
//

import Foundation

final class ResultsViewController: BaseTableViewController {
  
  //MARK: Constants
  let kFilterHeaderHeight: CGFloat = 50
  
  //MARK: Properties
  var textCleared = false
  let searchBar = UISearchBar()
  
  //MARK: Life Cycle Methods
  deinit {
    NSNotificationCenter.defaultCenter().removeObserver(self)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "locationWasUpdated:", name: kLocationUpdatedNotification, object: nil)
    
    let filterButton = UIBarButtonItem(image: UIImage(named: "sliders"), style: .Plain, target: self, action: "showFiltersWasPressed")
    navigationItem.rightBarButtonItem = filterButton
    
    queryManager = QueryManager(type: .Tap)
    
    cellReuseIdentifier = kTapCellReuseIdentifier
    tableView.registerNib(UINib(nibName: kTapNibName, bundle: nil), forCellReuseIdentifier: cellReuseIdentifier)

    dataSource = TableViewDataSource(cellReuseIdentifier: cellReuseIdentifier, configureCell: configureCell)
    tableView.dataSource = dataSource

    searchBar.delegate = self
    searchBar.placeholder = "Search For Available Beers"
    navigationItem.titleView = searchBar
    
    updateBrowseList()
  }

  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    tableView.estimatedRowHeight = kEstimatedCellHeight
    tableView.rowHeight = UITableViewAutomaticDimension
  }
  
  //MARK: Helper Methods
  override func updateBrowseList() {
    self.textCleared = false
    if let dataSource = dataSource where !dataSource.isEmpty {
      self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), atScrollPosition: .None, animated: false)
    }
    super.updateBrowseList()
  }

  func showFiltersWasPressed() {
    let filterViewNavController = storyboard?.instantiateViewControllerWithIdentifier("FilterViewNavController") as! UINavigationController
    let filterViewController = filterViewNavController.viewControllers.first as! FilterViewController
    filterViewController.filter = queryManager?.filter
    filterViewController.delegate = self
    presentViewController(filterViewNavController, animated: true, completion: nil)
  }
  
  func locationWasUpdated(notification: NSNotification) {
    updateBrowseList()
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
    
    let tap = dataSource?.objectAtIndexPath(indexPath) as! Tap
    let vc = TapDetailViewController()
    vc.tap = tap
    if let queryManager = queryManager {
      vc.filter = queryManager.filter
    }
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