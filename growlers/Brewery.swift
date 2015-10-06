//
//  Brewery.swift
//  growlers
//
//  Created by Chris Budro on 4/23/15.
//  Copyright (c) 2015 chrisbudro. All rights reserved.
//

import Foundation
import Parse

class Brewery: PFObject {
  
  @NSManaged var breweryName: String
  @NSManaged var breweryId: Int
  @NSManaged var city: String?
  @NSManaged var state: String?
  @NSManaged var imageUrl: String?
  @NSManaged var taps: [Tap]
  
}

extension Brewery: PFSubclassing {
  static func parseClassName() -> String {
    return kBreweryParseClassName
  }
}
