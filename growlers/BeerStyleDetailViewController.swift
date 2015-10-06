//
//  BeerStyleDetailViewController.swift
//  growlers
//
//  Created by Chris Budro on 9/28/15.
//  Copyright © 2015 chrisbudro. All rights reserved.
//

import Foundation

class BeerStyleDetailViewController: BaseTableViewController {
  
  var beerStyle: BeerStyle?

  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = beerStyle?.categoryName
    
    queryForTaps()
    
    CellReuseIdentifier = kTapCellReuseIdentifier
    tableView.registerNib(UINib(nibName: kTapNibName, bundle: nil), forCellReuseIdentifier: CellReuseIdentifier)
  }
  
  func queryForTaps() {
    if let beerStyle = beerStyle {
      activityIndicator.startAnimating()
      QueryManager.shared.tapsForObject(beerStyle, ofType: .BeerStyle) { (taps, error) -> Void in
        if let error = error {
          let alert = ErrorAlertController.alertControllerWithError(error)
          self.presentViewController(alert, animated: true, completion: nil)
        } else if let taps = taps {
          self.browseList = taps
          self.tableView.reloadData()
        }
        self.activityIndicator.stopAnimating()
      }
    }
  }
}
