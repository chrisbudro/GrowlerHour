//
//  BeerStyleDetailViewController.swift
//  growlers
//
//  Created by Chris Budro on 9/28/15.
//  Copyright © 2015 chrisbudro. All rights reserved.
//

import Foundation

class BeerStyleDetailViewController: BaseDetailViewController {
  
  var beerStyle: BeerStyle?

  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = beerStyle?.categoryName
    
//    cellReuseIdentifier = kTapCellReuseIdentifier
//    tableView.registerNib(UINib(nibName: kTapNibName, bundle: nil), forCellReuseIdentifier: cellReuseIdentifier)
//    
//    queryManager = GenericQueryManager(type: .BeerStyle)
//    
//    dataSource = TableViewDataSource(cellReuseIdentifier: cellReuseIdentifier, configureCell: configureCell)
//    tableView.dataSource = dataSource
//    
//    queryForTaps()
    

  }

  override func queryForTaps() {
    if let
      beerStyle = beerStyle,
      queryManager = queryManager {
        activityIndicator.startAnimating()
        queryManager.tapsForObject(beerStyle, ofType: .BeerStyle) { (taps, error) -> Void in
          if let error = error {
            let alert = ErrorAlertController.alertControllerWithError(error)
            self.presentViewController(alert, animated: true, completion: nil)
          } else if let taps = taps {
            self.dataSource?.updateObjectsWithArray(taps)
            self.tableView.reloadData()
          }
          self.activityIndicator.stopAnimating()
        }
    }
  }
}
