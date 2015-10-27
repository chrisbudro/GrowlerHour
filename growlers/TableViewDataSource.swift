//
//  TableViewDataSource.swift
//  growlers
//
//  Created by Chris Budro on 10/8/15.
//  Copyright © 2015 chrisbudro. All rights reserved.
//

import Foundation
import Parse

typealias ConfigureCellFunction = ((cell: UITableViewCell, object: AnyObject) -> Void)

class TableViewDataSource : NSObject, UITableViewDataSource {
  
  //MARK: Properties
  var objects = [AnyObject]()
  let cellReuseIdentifier: String
  let configureCell: ConfigureCellFunction

  var lastIndex: Int {
    return objects.count - 1
  }
  var objectCount: Int {
    return objects.count
  }
  var isEmpty: Bool {
    return objects.isEmpty
  }

  //MARK: Initializer
  init(cellReuseIdentifier: String, configureCell: ConfigureCellFunction) {
    self.cellReuseIdentifier = cellReuseIdentifier
    self.configureCell = configureCell
    
    super.init()
  }
  
  //MARK: Helper Methods
  func objectAtIndexPath(indexPath: NSIndexPath) -> AnyObject {
    return objects[indexPath.row]
  }
  
  func updateObjectsWithArray(newObjects: [AnyObject]) {
    objects = newObjects
  }
  
  func addObjects(newObjects: [AnyObject]) {
    objects += newObjects
  }
  
  func clearObjects() {
    objects = []
  }
  
  //MARK: TableView Data Source
  @objc func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return objects.count
  }

  @objc func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier, forIndexPath: indexPath)

    configureCell(cell: cell, object: objectAtIndexPath(indexPath))

    return cell
  }
}

