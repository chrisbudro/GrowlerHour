//
//  FilterPickerDataSource.swift
//  growlers
//
//  Created by Chris Budro on 10/15/15.
//  Copyright © 2015 chrisbudro. All rights reserved.
//

import Foundation

class FilterPickerDataSource: BaseDataSource {
  let objectType: ObjectType
  let filter: Filter
  
  init(objects: [AnyObject]?, cellReuseIdentifier: String, objectType: ObjectType, filter: Filter) {
    
    super.init(objects: objects, cellReuseIdentifier: cellReuseIdentifier)
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = super.tableView(tableView, cellForRowAtIndexPath: indexPath)
    let object = objects[indexPath.row]
    
    cell.accessoryType = isSelected(object) ? .Checkmark : .None
    
    return cell
  }
  
  func isSelected(beerStyle: BeerStyle) -> Bool {
    var isSelected = false
    
    switch objectType {
    case .Brewery:
      isSelected = filter.breweryIds.indexOf(beerStyle.categoryId) != nil ? true : false
    case .BeerStyle:
      isSelected = filter.categoryIds.indexOf(beerStyle.categoryId) != nil ? true : false
    case .Retailer:
      isSelected = filter.categoryIds.indexOf(beerStyle.categoryId) != nil ? true : false
    case .Tap:
      isSelected = filter.categoryIds.indexOf(beerStyle.categoryId) != nil ? true : false
      
    }
    
    return filter.categoryIds.indexOf(beerStyle.categoryId) != nil ? true : false
  }
}