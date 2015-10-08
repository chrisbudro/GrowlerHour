//
//  MainBrowseViewController.swift
//  growlers
//
//  Created by Chris Budro on 9/7/15.
//  Copyright (c) 2015 chrisbudro. All rights reserved.
//

import UIKit

enum BrowseBySelector: Int {
  case Location = 0
  case Brewery = 1
  case Style = 2
  case Retailer = 3
}

struct BrowseCell {
  static let brewery = "BreweryCell"
  static let retailer = "RetailerCell"
  static let category = "CategoryCell"
}

class MainBrowseViewController: UITableViewController {

  override func viewDidLoad() {
    navigationItem.titleView = UIImageView(image: UIImage(named: "GrowlerHour"))
    
  }
}

//MARK: Table View Delegate
extension MainBrowseViewController {
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    var viewController: UITableViewController?
    
    switch indexPath.row {
    case BrowseBySelector.Location.rawValue:
      viewController = NearbyBrowseViewController()
    case BrowseBySelector.Brewery.rawValue:
      viewController = BreweryBrowseTableViewController(style: .Plain)
    case BrowseBySelector.Style.rawValue:
      viewController = StyleBrowseTableViewController(style: .Plain)
    case BrowseBySelector.Retailer.rawValue:
      viewController = RetailerBrowseTableViewController(style: .Plain)
    default:
      viewController = BreweryBrowseTableViewController(style: .Plain)
    }

    navigationController?.pushViewController(viewController!, animated: true)
  }
}