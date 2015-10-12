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
  
  let kActivityIndicatorVerticalOffset: CGFloat = 80
  let kTableFooterViewHeight: CGFloat = 40

  var CellReuseIdentifier: String!
  var activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)

  var browseList: [PFObject] = []
  var queryManager: GenericQueryManager?

  override func viewDidLoad() {
    super.viewDidLoad()

    activityIndicator.center = CGPoint(x: view.frame.width / 2, y: (view.frame.height / 2) - kActivityIndicatorVerticalOffset)
    view.addSubview(activityIndicator)
    
    tableView.separatorStyle = .None
    tableView.delegate = self
    tableView.dataSource = self
    tableView.estimatedRowHeight = kEstimatedCellHeight
    tableView.rowHeight = UITableViewAutomaticDimension
  }
  
  func updateBrowseList() {
    browseList = []
    tableView.reloadData()
    activityIndicator.startAnimating()
    queryManager?.results { (results, error) -> Void in
      if let error = error {
        let alert = ErrorAlertController.alertControllerWithError(error)
        self.presentViewController(alert, animated: true, completion: nil)
      } else if let results = results {
        self.browseList = results
        self.tableView.reloadData()
      }
      self.activityIndicator.stopAnimating()
    }
  }
}


//MARK Table View Data Source
extension BaseTableViewController {
  
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return browseList.count
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(CellReuseIdentifier, forIndexPath: indexPath) as! BaseTableViewCell
    let cellObject: PFObject = browseList[indexPath.row]

    cell.configureCellForObject(cellObject)
    
    cell.imageRequest?.cancel()
    
    if let imageURL = cellObject[kParseImageUrlKey] as? String {
      cell.imageRequest = Alamofire.request(.GET, imageURL).responseImage(completionHandler: {
        (request, _, result) in
        switch result {
        case .Success(let image):
          cell.displayImage = image
        case .Failure(let data, let error):
          print(data)
          print(error)
          break
        }
      })
    }
    cell.setBackgroundShadow()
    return cell
  }
  

  override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    //TODO: Not a valid solution.  Need to solve UITableViewAutomaticDimension bug with insertRowAtIndexPaths
    return 100
  }
}


//MARK: Table View Delegate
extension BaseTableViewController {
  override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
    if let queryManager = queryManager where indexPath.row == (browseList.count - 1) {
      let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .White)
      tableView.tableFooterView = UIView(frame: CGRectMake(0, 0, view.frame.width, kTableFooterViewHeight))
      activityIndicator.center = CGPoint(x: tableView.tableFooterView!.frame.width / 2, y: tableView.tableFooterView!.frame.height / 2)
      tableView.tableFooterView?.addSubview(activityIndicator)
      activityIndicator.startAnimating()
      let skipCount = self.browseList.count
      queryManager.loadMoreWithSkipCount(skipCount) { (results, error) -> Void in
        if let results = results where results.count > 0 {
          self.browseList = self.browseList + results
          
          let indexRange = skipCount..<self.browseList.count
          let indexArray = indexRange.map() { return NSIndexPath(forRow: $0, inSection: 0) }
          
          
          tableView.beginUpdates()
          tableView.insertRowsAtIndexPaths(indexArray, withRowAnimation: UITableViewRowAnimation.Fade)
          //        tableView.tableFooterView = nil
          tableView.endUpdates()
          activityIndicator.stopAnimating()
        } else {
          tableView.tableFooterView = nil
        }
      }
    }
  }
}




