//
//  GenericQueryManager.swift
//  growlers
//
//  Created by Chris Budro on 10/2/15.
//  Copyright © 2015 chrisbudro. All rights reserved.
//

import Foundation
import CoreLocation
import Parse

enum ObjectType {
  case Retailer
  case Brewery
  case BeerStyle
  case Tap
}

enum LocationFilterMethod {
  case CurrentLocation
  case CustomLocation(LocationDetails)
  case None
}

class GenericQueryManager {
  let type: ObjectType
  typealias completionHandler = ((results: [PFObject]?, error: NSError?) -> Void)
  
  let kDefaultQueryLimit: Int = 50
  let kDefaultQueryMaxDistance: Double = 50
  
  var filter = Filter() {
    didSet {
      isDirty = true
    }
  }
  var isDirty = true
  var locationFilterMethod: LocationFilterMethod = .None
  var currentLocation: CLLocation?
  var currentGeoPoint: PFGeoPoint?
  var currentQuery: PFQuery?
  let locationService = LocationService.shared
  
  
  init(type: ObjectType) {
    self.type = type
  }
  
  convenience init(type: ObjectType, filter: Filter) {
    self.init(type: type)
    self.filter = filter
  }

  func results(completion: completionHandler) {
    let query = Tap.query()!
    query.limit = kDefaultQueryLimit
    
    if let searchTerm = filter.searchTerm {
      let searchKeywords = keywordsFromSearchTerm(searchTerm)
      query.whereKey("searchKeywords", containsAllObjectsInArray: searchKeywords)
    }
    
    query.whereKey("abv", greaterThanOrEqualTo: filter.abvRange.min)
    query.whereKey("abv", lessThanOrEqualTo: filter.abvRange.max)
    
//    if !filter.retailerIds.isEmpty && type != .Retailer {
//      let retailerQuery = Retailer.query()!
//      retailerQuery.whereKey("retailerId", containedIn: filter.retailerIds)
//
//      query.whereKey("retailers", matchesQuery: retailerQuery)
//    }
    
    if !filter.breweryIds.isEmpty && type != .Brewery {
      let breweryQuery = Brewery.query()!
      breweryQuery.whereKey("breweryId", containedIn: Array(filter.breweryIds))
      query.whereKey("brewery", matchesQuery: breweryQuery)
    }
    
    if !filter.categoryIds.isEmpty && type != .BeerStyle {
      let categoryQuery = BeerStyle.query()!
      categoryQuery.whereKey("categoryId", containedIn: filter.categoryIds)
      
      query.whereKey("categories", matchesQuery: categoryQuery)
    }
    
    if !filter.tapIds.isEmpty {
      query.whereKey("beerId", containedIn: filter.tapIds)

    }
    
    if ( filter.includeMisc == false ) {
      query.whereKey("categories", notEqualTo: PFObject(withoutDataWithClassName: "Categories", objectId: "Go0XwcsbTo"))
    }
    
    if ( filter.includeCider == false ) {
      query.whereKey("categories", notEqualTo: PFObject(withoutDataWithClassName: "Categories", objectId: "Ram0dmMRPd"))
    }

    let geoQueryGroup = dispatch_group_create()
    
    func prepareRetailerQuery() {
      if let locationDetails = filter.locationDetails {
        let latitude = locationDetails.coordinate.latitude
        let longitude = locationDetails.coordinate.longitude
        self.currentGeoPoint = PFGeoPoint(latitude: latitude, longitude: longitude)
      }
      let retailerQuery = Retailer.query()!
      if let currentGeoPoint = currentGeoPoint {
        retailerQuery.whereKey("coordinates", nearGeoPoint: currentGeoPoint, withinMiles: self.filter.maxDistance)
      }
      if !filter.retailerIds.isEmpty && type != .Retailer {
        retailerQuery.whereKey("retailerId", containedIn: filter.retailerIds)
      }
      query.whereKey("retailers", matchesQuery: retailerQuery)
      dispatch_group_leave(geoQueryGroup)
    }
    
    switch locationFilterMethod {
    case .CurrentLocation:
      if let _ = self.filter.locationDetails {
        dispatch_group_enter(geoQueryGroup)
        prepareRetailerQuery()
      } else if let currentLocationDetails = LocationService.shared.locationDetails {
        dispatch_group_enter(geoQueryGroup)
        self.filter.locationDetails = currentLocationDetails
        prepareRetailerQuery()
      } else {
        dispatch_group_enter(geoQueryGroup)
        LocationService.shared.startMonitoringLocation { (locationDetails, error) -> Void in
          if let error = error {
            completion(results: nil, error: error)
          } else if let locationDetails = locationDetails {
            self.filter.locationDetails = locationDetails
            prepareRetailerQuery()
          }
        }
      }
    case .CustomLocation:
      dispatch_group_enter(geoQueryGroup)
      if let _ = filter.locationDetails {
        prepareRetailerQuery()
      } else {
        let error = ErrorHandler.errorWithMessage("Please select a location in the Filter menu")
        completion(results: nil, error: error)
      }
    case .None:
      dispatch_group_enter(geoQueryGroup)
      prepareRetailerQuery()
    }
 
    dispatch_group_notify(geoQueryGroup, dispatch_get_main_queue()) {
      if self.type == .Tap {
        self.currentQuery = query
      } else {
        let matchQuery = self.newQuery()
        matchQuery.whereKey("taps", matchesQuery: query)
        self.currentQuery = matchQuery
      }
      
      self.currentQuery?.orderBySortDescriptor(self.filter.sortDescriptor)
      
      self.currentQuery?.findObjectsInBackgroundWithBlock { (results, error) in
        if let error = error {
          completion(results: nil, error: error)
        } else if let results = results as? [Retailer] where self.type == .Retailer {
          
          let resultsWithDistance: [Retailer] = results.map() { (retailer) -> Retailer in
            let distance = self.distanceFromCurrentLocationToRetailer(retailer)
            retailer.distanceFromLocation = distance
            return retailer
          }
          completion(results: resultsWithDistance, error: nil)
          
        } else if let results = results {
          completion(results: results, error: nil)
        }

      }
    }
  }
  
  func distanceFromCurrentLocationToRetailer(retailer: Retailer) -> Double? {
    if let
      lat = self.filter.locationDetails?.coordinate.latitude,
      long = self.filter.locationDetails?.coordinate.longitude {
        let currentLocation = CLLocation(latitude: lat, longitude: long)
        let distanceInMeters = currentLocation.distanceFromLocation(retailer.coreLocation)
        let distanceInMiles = distanceInMeters * kMetersToMilesConversionMultiplier
        let distanceInMilesWithTwoDecimalPlaces = Double(round(distanceInMiles*100)/100)
        return distanceInMilesWithTwoDecimalPlaces
    }
    return nil
  }
  
  func newQuery() -> PFQuery {
    var query: PFQuery!
    
    switch type {
    case .Retailer:
      query = Retailer.query()!
    case .Brewery:
      query = Brewery.query()!
    case .Tap:
      query = Tap.query()!
    case .BeerStyle:
      query = BeerStyle.query()!
    }
    return query
  }

  func keywordsFromSearchTerm(searchTerm: String) -> [String] {
    let splitString = searchTerm.characters.split { $0 == " " }.map { String($0) }
    var searchKeywords = splitString.map( { return $0.lowercaseString } )
    let stopWords = ["company", "co", "co.", "brewery", "brewing", "beer"]
    searchKeywords = searchKeywords.filter( { return !stopWords.contains($0) } )
    
    return searchKeywords
  }
  
  func loadMoreWithSkipCount(skipCount: Int, completion: completionHandler) {
    currentQuery?.skip = skipCount
    currentQuery?.findObjectsInBackgroundWithBlock { (results, error) in
      if let error = error {
        completion(results: nil, error: error)
      } else if let results = results {
        completion(results: results, error: nil)
      }
    }
  }
}

