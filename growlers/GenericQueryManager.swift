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

//enum LocationFilterMethod {
//  case CurrentLocation
//  case CustomLocation(LocationDetails)
//  case None
//}

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
//  var locationFilterMethod: LocationFilterMethod = .None
//  var currentLocation: CLLocation?
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
  
  //MARK: Queries

  func results(completion: completionHandler) {
    let query = Tap.query()!
    query.limit = kDefaultQueryLimit
    
    if let searchTerm = filter.searchTerm {
      let searchKeywords = keywordsFromSearchTerm(searchTerm)
      query.whereKey("searchKeywords", containsAllObjectsInArray: searchKeywords)
    }
    
    query.whereKey("abv", greaterThanOrEqualTo: filter.abvRange.min)
    query.whereKey("abv", lessThanOrEqualTo: filter.abvRange.max)
    
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

    filter.locationGeoPoint { (locationGeoPoint, error) -> Void in
      if let error = error {
        completion(results: nil, error: error)
      } else if let locationGeoPoint = locationGeoPoint {
        self.currentGeoPoint = locationGeoPoint
        let retailerQuery = Retailer.query()!
        retailerQuery.whereKey("coordinates", nearGeoPoint: locationGeoPoint, withinMiles: self.filter.maxDistance)

        if !self.filter.retailerIds.isEmpty && self.type != .Retailer {
          retailerQuery.whereKey("retailerId", containedIn: self.filter.retailerIds)
        }
        query.whereKey("retailers", matchesQuery: retailerQuery)

//        if self.type == .Tap {
//          self.currentQuery = query
//          self.currentQuery?.orderBySortDescriptor(self.filter.sortDescriptor)
//        } else {
//          let matchQuery = self.newQueryFromQuery(query)
//          self.currentQuery = matchQuery
//        }
        
        self.currentQuery = self.newQueryFromQuery(query)
        
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
  }
  
//  func testGeoQuery(completion: (results: [Retailer]?, error: NSError?) -> Void) {
//    let query = Retailer.query()!
//    query.whereKey("coordinates", nearGeoPoint: PFGeoPoint(latitude: 45.5191, longitude: -122.615984))
//    
//    query.findObjectsInBackgroundWithBlock { (results, error) -> Void in
//      if let results = results as? [Retailer] {
//        completion(results: results, error: nil)
//      }
//    }
//  }

  func tapsForObject(object: PFObject, ofType objectType: ObjectType, completionHandler: (taps: [Tap]?, error: NSError?) -> Void) {
    let query = Tap.query()!
    query.limit = kDefaultQueryLimit
    
    let retailerQuery = Retailer.query()!
    
    switch objectType {
    case .Brewery:
      if let brewery = object as? Brewery {
        query.whereKey("brewery", equalTo: brewery)
      }
    case .BeerStyle:
      if let beerStyle = object as? BeerStyle {
        query.whereKey("categories", equalTo: beerStyle)
      }
    case .Retailer:
      if let retailer = object as? Retailer {
        query.whereKey("retailers", equalTo: retailer)
      }
    default:
      let error = NSError(domain: kGrowlerErrorDomain, code: kGrowlerDefaultErrorCode, userInfo: [NSLocalizedDescriptionKey: "There was an error retrieving taps for this items.  Please try again later"])
      completionHandler(taps: nil, error: error)
    }
    
    filter.locationGeoPoint { (locationGeoPoint, error) -> Void in
      if let locationGeoPoint = locationGeoPoint where objectType != .Retailer {
        retailerQuery.whereKey("coordinates", nearGeoPoint: locationGeoPoint, withinMiles: self.filter.maxDistance)
        query.whereKey("retailers", matchesQuery: retailerQuery) 
      }
      
      self.currentQuery = query
      
      query.findObjectsInBackgroundWithBlock { (taps, error) -> Void in
        if let error = error {
          completionHandler(taps: nil, error: error)
        } else if let taps = taps as? [Tap] {
          completionHandler(taps: taps, error: nil)
        }
      }
    }
  }
  
  //MARK: Helper Methods
  
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
  
  func newQueryFromQuery(queryToMatch: PFQuery) -> PFQuery {
    var query: PFQuery!
    
    switch type {
    case .Retailer:
      query = Retailer.query()!
      if let currentGeoPoint = currentGeoPoint {
        query.whereKey("coordinates", nearGeoPoint: currentGeoPoint, withinMiles: self.filter.maxDistance)
      }
    case .Brewery:
      query = Brewery.query()!
      query.whereKey("taps", matchesQuery: queryToMatch)
      query.orderByAscending("breweryName")
    case .Tap:
      query = queryToMatch
      query.orderBySortDescriptor(self.filter.sortDescriptor)
    case .BeerStyle:
      query = BeerStyle.query()!
      query.whereKey("taps", matchesQuery: queryToMatch)
      query.orderByAscending("categoryName")
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
    if let currentQuery = currentQuery {
      currentQuery.skip = skipCount
      currentQuery.findObjectsInBackgroundWithBlock { (results, error) in
        if let error = error {
          completion(results: nil, error: error)
        } else if let results = results {
          completion(results: results, error: nil)
        }
      }
    } else {
      let error = NSError(domain: kGrowlerErrorDomain, code: kGrowlerDefaultErrorCode, userInfo: [NSLocalizedDescriptionKey: "There was an error loading more items.  Please try again"])
      completion(results: nil, error: error)
    }
  }
}

