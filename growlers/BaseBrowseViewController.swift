//
//  BaseBrowseViewController.swift
//  growlers
//
//  Created by Chris Budro on 10/23/15.
//  Copyright © 2015 chrisbudro. All rights reserved.
//

import UIKit

class BaseBrowseViewController: BaseTableViewController {
  
  let kSearchBarHeight: CGFloat = 40
  
  var searchBar = UISearchBar()
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //TODO: Implement Search Functionality on browse lists
//    searchBar.frame = CGRect(x: 0, y: 0, width: self.tableView.frame.width, height: kSearchBarHeight)
//    tableView.tableHeaderView = searchBar
    
  }
}

extension BaseBrowseViewController: UITextFieldDelegate {
  func textFieldDidEndEditing(textField: UITextField) {
    
  }
  
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
}
