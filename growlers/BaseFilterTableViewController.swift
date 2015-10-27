//
//  BaseFilterTableViewController.swift
//  growlers
//
//  Created by Chris Budro on 9/30/15.
//  Copyright © 2015 chrisbudro. All rights reserved.
//

import Foundation

class BaseFilterTableViewController: BaseTableViewController {
  //MARK: Properties
  var delegate: FilterDelegate?
  
  //MARK: Life Cycle Methods
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureCell = { (cell, object) in
      if let
        configurableCell = cell as? ConfigurableCell,
        object = object as? Filterable {
          configurableCell.configureCellForObject(object)
          cell.accessoryType = self.isSelected(object) ? .Checkmark : .None
      }
    }
  }
  
  //MARK: Helper Methods
  func isSelected(object: Filterable) -> Bool {
    if let queryManager = queryManager {
      return queryManager.filter.isInFilter(object)
    } else {
      return false
    }
  }
}