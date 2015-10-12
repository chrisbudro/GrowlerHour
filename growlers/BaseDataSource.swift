//
//  BaseDataSource.swift
//  growlers
//
//  Created by Chris Budro on 10/8/15.
//  Copyright © 2015 chrisbudro. All rights reserved.
//

import Foundation
import Parse

typealias ConfigureCellFunction = ((cell: UITableViewCell, object: PFObject) -> Void)

class BaseDataSource<T: PFObject> {
  var objects = [T]()
  let cellReuseIdentifier: String
  let configureCell: ConfigureCellFunction

  init(objects: [T], cellReuseIdentifier: String, configureCell: ConfigureCellFunction) {
    self.objects = objects
    self.cellReuseIdentifier = cellReuseIdentifier
    self.configureCell = configureCell
  }
  
  func objectAtIndexPath(indexPath: NSIndexPath) -> T {
    return objects[indexPath.row]
  }

  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return objects.count
  }

  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier, forIndexPath: indexPath)
    let cellObject: T = objects[indexPath.row]
    
//    cell.configureCellForObject(cellObject)
    self.configureCell(cell: cell, object: objectAtIndexPath(indexPath))
    
    cell.imageRequest?.cancel()
    
//    if let imageURL = cellObject[kParseImageUrlKey] as? String {
//      cell.imageRequest = Alamofire.request(.GET, imageURL).responseImage(completionHandler: {
//        (request, _, result) in
//        switch result {
//        case .Success(let image):
//          cell.displayImage = image
//        case .Failure(let data, let error):
//          print(data)
//          print(error)
//          break
//        }
//      })
//    }
    cell.setBackgroundShadow()
    return cell
  }
}

