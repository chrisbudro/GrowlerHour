//
//  Retailer.swift
//  growlers
//
//  Created by Chris Budro on 5/14/15.
//  Copyright (c) 2015 chrisbudro. All rights reserved.
//

import UIKit
import Parse

class Retailer: PFObject {
  
  @NSManaged var retailerName: String
  @NSManaged var retailerId: String
  @NSManaged var taps: [Tap]
  @NSManaged var streetAddress: String
  @NSManaged var city: String
  @NSManaged var state: String
  @NSManaged var coordinates: PFGeoPoint
  @NSManaged var imageUrl: String?
  @NSManaged var photo: PFFile?
  var distanceFromLocation: Double?
  
  var coreLocation: CLLocation {
    return CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude)
  }
  
}

extension Retailer: PFSubclassing {
  static func parseClassName() -> String {
    return kRetailerParseClassName
  }
}

extension Retailer: Filterable {
  var id: String {
    return retailerId
  }
}

