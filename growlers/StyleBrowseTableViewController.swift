//
//  StyleBrowseTableViewController.swift
//  growlers
//
//  Created by Chris Budro on 9/8/15.
//  Copyright (c) 2015 chrisbudro. All rights reserved.
//

import UIKit

class StyleBrowseTableViewController: BaseTableViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Styles"
    
    CellReuseIdentifier = kStyleCellReuseIdentifier
    tableView.registerNib(UINib(nibName: kBeerStyleNibName, bundle: nil), forCellReuseIdentifier: CellReuseIdentifier)
    
    queryManager = GenericQueryManager(type: .BeerStyle)
    updateBrowseList()
  }
}

//MARK: Table View Delegate
extension StyleBrowseTableViewController {
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let vc = BeerStyleDetailViewController(style: .Plain)
    if let beerStyle = browseList[indexPath.row] as? BeerStyle {
      vc.beerStyle = beerStyle
    }
    navigationController?.pushViewController(vc, animated: true)
  }
}


