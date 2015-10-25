//
//  MainBrowseViewController.swift
//  growlers
//
//  Created by Chris Budro on 9/7/15.
//  Copyright (c) 2015 chrisbudro. All rights reserved.
//

import UIKit

enum BrowseBySelector: Int {
  case Brewery = 0
  case Style = 1
  case Retailer = 2
  case PoweredBy = 3
}

struct BrowseCell {
  static let brewery = "BreweryCell"
  static let retailer = "RetailerCell"
  static let category = "CategoryCell"
}

final class MainBrowseViewController: UITableViewController {
  
  let numberOfCells: CGFloat = 3
  let kPoweredByCellHeight: CGFloat = 60
  
  var filter = Filter()

  override func viewDidLoad() {

    filter.retrieveLocationDetails { (locationDetails, error) -> Void in
      self.filter.locationDetails = locationDetails
    }
    
    navigationItem.titleView = UIImageView(image: UIImage(named: "GrowlerHour"))
    let filterButton = UIBarButtonItem(image: UIImage(named: "sliders"), style: .Plain, target: self, action: "showFiltersWasPressed")
    navigationItem.rightBarButtonItem = filterButton
  }
  
  func showFiltersWasPressed() {
    let filterViewNavController = storyboard?.instantiateViewControllerWithIdentifier("FilterViewNavController") as! UINavigationController
    let filterViewController = filterViewNavController.viewControllers.first as! FilterViewController
    filterViewController.filter = filter
    filterViewController.delegate = self
    presentViewController(filterViewNavController, animated: true, completion: nil)
  }
}

//MARK: Table View Delegate
extension MainBrowseViewController {
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    var viewController: BaseTableViewController?
    
    switch indexPath.row {
    case BrowseBySelector.Brewery.rawValue:
      viewController = BreweryBrowseTableViewController(style: .Plain)
      let queryManager = GenericQueryManager(type: .Brewery, filter: filter)
      viewController?.queryManager = queryManager
    case BrowseBySelector.Style.rawValue:
      viewController = StyleBrowseTableViewController(style: .Plain)
      let queryManager = GenericQueryManager(type: .BeerStyle, filter: filter)
      viewController?.queryManager = queryManager
    case BrowseBySelector.Retailer.rawValue:
      viewController = RetailerBrowseTableViewController(style: .Plain)
      let queryManager = GenericQueryManager(type: .Retailer, filter: filter)
      viewController?.queryManager = queryManager
    default:
      break
    }
    
    if let viewController = viewController {
      navigationController?.pushViewController(viewController, animated: true)
    }
  }
  
  override func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    if indexPath.row == BrowseBySelector.PoweredBy.rawValue {
      return false
    }
    return true
  }
  
  override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    if indexPath.row == BrowseBySelector.PoweredBy.rawValue {
      return kPoweredByCellHeight
    }
    return view.bounds.height / numberOfCells
  }
}



//MARK: Filter Delegate
extension MainBrowseViewController: FilterDelegate {
  func filterWasUpdated(filter: Filter) {
    self.filter = filter
//    queryManager?.filter.isDirty = false
//    updateBrowseList()
  }
}