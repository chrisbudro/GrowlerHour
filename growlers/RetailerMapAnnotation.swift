//
//  RetailerMapAnnotation.swift
//  GrowlerHour
//
//  Created by Chris Budro on 11/1/15.
//  Copyright © 2015 chrisbudro. All rights reserved.
//

import Foundation
import MapKit

class RetailerMapAnnotation: NSObject, MKAnnotation {
  let retailer: Retailer
  var coordinate: CLLocationCoordinate2D {
    return retailer.coreLocation.coordinate
  }

  init(retailer: Retailer) {
    self.retailer = retailer
    super.init()
  }
}
