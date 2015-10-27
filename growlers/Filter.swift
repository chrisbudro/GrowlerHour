//
//  Query.swift
//  growlers
//
//  Created by Chris Budro on 5/1/15.
//  Copyright (c) 2015 chrisbudro. All rights reserved.
//

import Foundation
import Parse

enum SortOrder: String {
  case Brewery = "breweryName"
  case Beer = "beerTitle"
  case WhenTapped = "createdAt"
}

protocol Filterable: class {
  var id: String {get}
}

typealias LocationDetails = (name: String, coordinate: CLLocationCoordinate2D)

let kDefaultMinAbvValue = 0
let kDefaultMaxAbvValue = 15

let kDefaultMinIbuValue = 0
let kDefaultMaxIbuValue = 3000

let kDefaultMaxSearchDistance: Double = 50
let kDefaultLocationDetails: LocationDetails = (name: "Portland", coordinate: CLLocationCoordinate2DMake(45.523193, -122.672053))

struct Filter {
  //MARK: Properties
  var breweryIds: [Int]
  var categoryIds: [String]
  var tapIds: [Int]
  var retailerIds: [String]
  
  var locationDetails: LocationDetails? {
    didSet {
      isDirty = true
    }
  }
  var abvRange: (min: Int, max: Int) {
    didSet {
      isDirty = true
    }
  }
  var ibuRange: (min: Int, max: Int) {
    didSet {
      isDirty = true
    }
  }
  var maxDistance: Double {
    didSet {
      isDirty = true
    }
  }
  var sortDescriptor: NSSortDescriptor {
    didSet {
      isDirty = true
    }
  }
  var searchTerm: String? {
    didSet {
      isDirty = true
    }
  }
  var includeMisc: Bool {
    didSet {
      isDirty = true
    }
  }
  var includeCider: Bool {
    didSet {
      isDirty = true
    }
  }
  var isDirty = false {
    willSet {
      if newValue {
        NSNotificationCenter.defaultCenter().postNotificationName(kFilterIsDirtyNotification, object: nil)
      }
    }
  }
  
  //MARK: Initializer
  init() {
    self.breweryIds = []
    self.categoryIds = []
    self.tapIds = []
    self.retailerIds = []
    self.abvRange = (min: kDefaultMinAbvValue, max: kDefaultMaxAbvValue)
    self.ibuRange = (min: kDefaultMinIbuValue, max: kDefaultMaxIbuValue)
    self.sortDescriptor = NSSortDescriptor(key: SortOrder.WhenTapped.rawValue, ascending: true)
    self.maxDistance = kDefaultMaxSearchDistance
    self.includeMisc = false
    self.includeCider = false
  }
  
  //MARK: Helper Methods
  mutating func clearFilter() {
    self = Filter()
    isDirty = true
  }
  
  mutating func addBrewery(brewery: Brewery) {
    breweryIds.append(brewery.breweryId)
    isDirty = true
  }
  
  mutating func removeBrewery(brewery: Brewery) {
    if let index = breweryIds.indexOf(brewery.breweryId) {
      breweryIds.removeAtIndex(index)
      isDirty = true
    }
  }
  
  mutating func addRetailer(retailer: Retailer) {
    retailerIds.append(retailer.retailerId)
    isDirty = true
  }
  
  mutating func removeRetailer(retailer: Retailer) {
    if let index = retailerIds.indexOf(retailer.retailerId) {
      retailerIds.removeAtIndex(index)
      isDirty = true
    }
  }
  
  mutating func addBeerStyle(beerStyle: BeerStyle) {
    categoryIds.append(beerStyle.categoryId)
    isDirty = true
  }
  
  mutating func removeBeerStyle(beerStyle: BeerStyle) {
    if let index = categoryIds.indexOf(beerStyle.categoryId) {
      categoryIds.removeAtIndex(index)
      isDirty = true
    }
  }
  
  mutating func addTap(tap: Tap) {
    tapIds.append(tap.beerId)
    isDirty = true
  }
  
  mutating func removeTap(tap: Tap) {
    if let index = tapIds.indexOf(tap.beerId) {
      tapIds.removeAtIndex(index)
      isDirty = true
    }
  }
  
  func isInFilter(object: Filterable) -> Bool {
    var inFilter = false
    
    switch object {
    case is Brewery:
      let brewery = object as! Brewery
      //TODO: Refactor brewery and tap ID Types
      inFilter = breweryIds.indexOf(brewery.breweryId) != nil ? true : false
    case is Retailer:
      inFilter = retailerIds.indexOf(object.id) != nil ? true : false
    case is BeerStyle:
      inFilter = categoryIds.indexOf(object.id) != nil ? true : false
    default:
      break
    }
    return inFilter
  }

  //MARK: Location Details
  mutating func retrieveLocationDetails(completion: (locationDetails: LocationDetails?, error: NSError?) -> Void) {
    if let locationDetails = locationDetails {
      completion(locationDetails: locationDetails, error: nil)
    } else if let currentLocationDetails = LocationService.shared.locationDetails {
      locationDetails = currentLocationDetails
      completion(locationDetails: locationDetails, error: nil)
    } else {
      LocationService.shared.startMonitoringLocation { (newLocationDetails, error) -> Void in
        if let _ = error {
          self.locationDetails = kDefaultLocationDetails
        } else if let newLocationDetails = newLocationDetails {
          self.locationDetails = newLocationDetails
        }
        completion(locationDetails: self.locationDetails, error: nil)
      }
    }
  }
  
  mutating func locationGeoPoint(completion: (locationGeoPoint: PFGeoPoint?, error: NSError?) -> Void) {
    retrieveLocationDetails { (locationDetails, error) -> Void in
      if let error = error {
        completion(locationGeoPoint: nil, error: error)
      } else if let locationDetails = locationDetails {
        let coordinate = locationDetails.coordinate
        let geoPoint = PFGeoPoint(latitude: coordinate.latitude, longitude: coordinate.longitude)
        completion(locationGeoPoint: geoPoint, error: nil)
      }
    }
  }
  

}