//
//  BaseDetailViewController.swift
//  growlers
//
//  Created by Chris Budro on 10/4/15.
//  Copyright © 2015 chrisbudro. All rights reserved.
//

import UIKit
import Parse

class BaseDetailViewController: BaseTableViewController {
  var parentObject: PFObject?

  override func viewDidLoad() {
    super.viewDidLoad()

    fetchTaps()
  }
  
  func fetchTaps() {
    if let parentObject = parentObject {
      activityIndicator.startAnimating()
      if let taps = parentObject[kParseTapsRelationKey] as? [Tap] {
        PFObject.fetchAllIfNeededInBackground(taps) { (taps, error) in
          if let error = error {
            let alert = ErrorAlertController.alertControllerWithError(error);
            self.presentViewController(alert, animated: true, completion: nil);
          } else if let taps = taps as? [Tap] {
            self.browseList = taps
            self.tableView.reloadData()
          }
          self.activityIndicator.stopAnimating()
        }
      }
    }
  }
}