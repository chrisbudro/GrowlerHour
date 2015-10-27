//
//  BeerStyleDetailViewController.swift
//  growlers
//
//  Created by Chris Budro on 9/28/15.
//  Copyright © 2015 chrisbudro. All rights reserved.
//

import Foundation

class BeerStyleDetailViewController: BaseDetailViewController {
  
  //MARK: Properties
  var beerStyle: BeerStyle?

  //MARK: Life Cycle Methods
  override func viewDidLoad() {
    super.viewDidLoad()
    title = beerStyle?.categoryName
  }

  //MARK: Helper Methods
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
