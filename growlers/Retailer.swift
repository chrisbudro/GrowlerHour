//
//  Retailer.swift
//  growlers
//
//  Created by Chris Budro on 5/14/15.
//  Copyright (c) 2015 chrisbudro. All rights reserved.
//

import UIKit
import Parse

class Retailer: PFObject, GMSMappable {
  
  @NSManaged var retailerName: String
  @NSManaged var retailerId: String
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
  
  lazy var mapMarker: GMSMarker = {
    let marker = GMSMarker(position: self.coreLocation.coordinate)
    marker.title = self.retailerName
    marker.snippet = self.streetAddress
    marker.userData = self
    
    return marker
  }()

  func distanceFromSelectedLocation(completion: (distance: Double?, error: NSError?) -> Void) {
    LocationService.shared.selectedLocationIfAvailable { (locationDetails, error) -> Void in
      if let error = error {
        completion(distance: nil, error: error)
      } else if let locationDetails = locationDetails {
        let lat = locationDetails.coordinate.latitude
        let long = locationDetails.coordinate.longitude
        let currentLocation = CLLocation(latitude: lat, longitude: long)
        let distanceInMeters = currentLocation.distanceFromLocation(self.coreLocation)
        let distanceInMiles = distanceInMeters * kMetersToMilesConversionMultiplier
        let distanceInMilesWithTwoDecimalPlaces = Double(round(distanceInMiles*100)/100)
        
        completion(distance: distanceInMilesWithTwoDecimalPlaces, error: nil)
      }
    }
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


