//
//  BaseTableViewController.swift
//  growlers
//
//  Created by Chris Budro on 9/7/15.
//  Copyright (c) 2015 chrisbudro. All rights reserved.
//

import UIKit
import Parse
import Alamofire
import AlamofireImage

class BaseTableViewController: UITableViewController {
  
  //MARK: Constants
  let kActivityIndicatorVerticalOffset: CGFloat = 80
  let kTableFooterViewHeight: CGFloat = 40

  //MARK: Properties
  var cellReuseIdentifier: String!
  var activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)

  var queryManager: QueryManager?
  var dataSource: TableViewDataSource?
  var configureCell: ConfigureCellFunction!
  
  var noResultsBackgroundView: UIView!

  //MARK: Life Cycle Methods
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let bgViews = NSBundle.mainBundle().loadNibNamed("NoResultsBackgroundView", owner: self, options: nil)
    noResultsBackgroundView = bgViews.first as! UIView

    activityIndicator.center = CGPoint(x: view.frame.width / 2, y: (view.frame.height / 2) - kActivityIndicatorVerticalOffset)
    view.addSubview(activityIndicator)
    
    tableView.separatorStyle = .None
    tableView.delegate = self
    tableView.estimatedRowHeight = kEstimatedCellHeight
    tableView.rowHeight = UITableViewAutomaticDimension
    
    configureCell = { (cell, object) in
      if let cell = cell as? ConfigurableCell {
        cell.configureCellForObject(object)
      }
    }
  }

  //MARK: Helper Methods
  func updateBrowseList() {
    dataSource?.clearObjects()
    tableView.reloadData()
    activityIndicator.startAnimating()
    queryManager?.results { (results, error) -> Void in
      if let error = error {
        let alert = ErrorAlertController.alertControllerWithError(error)
        self.presentViewController(alert, animated: true, completion: nil)
      } else if let results = results {
        self.dataSource?.updateObjectsWithArray(results)
        self.tableView.backgroundView = results.count > 0 ? nil : self.noResultsBackgroundView
        self.tableView.reloadData()
      }
      self.activityIndicator.stopAnimating()
    }
  }
}

//MARK: Table View Delegate
extension BaseTableViewController {
  override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
    if let
      dataSource = dataSource,
      queryManager = queryManager where indexPath.row == (dataSource.lastIndex) {
      let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .White)
      tableView.tableFooterView = UIView(frame: CGRectMake(0, 0, view.frame.width, kTableFooterViewHeight))
      activityIndicator.center = CGPoint(x: tableView.tableFooterView!.frame.width / 2, y: tableView.tableFooterView!.frame.height / 2)
      tableView.tableFooterView?.addSubview(activityIndicator)
      activityIndicator.startAnimating()
      let skipCount = dataSource.objectCount
      queryManager.loadMoreWithSkipCount(skipCount) { (results, error) -> Void in
        if let results = results where results.count > 0 {
          dataSource.addObjects(results)
          
          let indexRange = skipCount..<dataSource.objectCount
          let indexArray = indexRange.map() { return NSIndexPath(forRow: $0, inSection: 0) }
          
          tableView.beginUpdates()
          tableView.insertRowsAtIndexPaths(indexArray, withRowAnimation: UITableViewRowAnimation.Fade)
          tableView.endUpdates()
          activityIndicator.stopAnimating()
        } else {
          tableView.tableFooterView = nil
        }
      }
    }
  }
  
  override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    //TODO: Not a valid solution.  Need to solve UITableViewAutomaticDimension bug with insertRowAtIndexPaths
    return 100
  }
}




