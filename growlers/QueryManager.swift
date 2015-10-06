//
//  QueryManager.swift
//  growlers
//
//  Created by Chris Budro on 5/5/15.
//  Copyright (c) 2015 chrisbudro. All rights reserved.
//

// In the process of refactoring out this class.  The updated class is GenericQueryManager

import CoreLocation
import Parse

typealias breweriesCompletionHandler = ((breweries: [Brewery]?, error: NSError?) -> Void)
typealias retailersCompletionHandler = ((retailers: [Retailer]?, error: NSError?) -> Void)
typealias tapsCompletionHandler = ((taps: [Tap]?, error: NSError?) -> Void)

class QueryManager: NSObject {
  static let shared = QueryManager()
  
  let kFeedHistoryLengthInSeconds: NSTimeInterval = -1200000 // Two Weeks
  let kDefaultQueryLimit: Int = 50
  let kDefaultQueryMaxDistance: Double = 50
  
  var filter = Filter() {
    didSet {
      isDirty = true
    }
  }
  var isDirty = true
//  let locationManager = CLLocationManager()
  var currentLocation: CLLocation?
  var currentGeoPoint: PFGeoPoint?
  var currentQuery: PFQuery?
  
  

  
  func keywordsFromSearchTerm(searchTerm: String) -> [String] {
    let splitString = searchTerm.characters.split { $0 == " " }.map { String($0) }
    var searchKeywords = splitString.map( { return $0.lowercaseString } )
    let stopWords = ["company", "co", "co.", "brewery", "brewing", "beer"]
    searchKeywords = searchKeywords.filter( { return !stopWords.contains($0) } )
    
    return searchKeywords
  }

  // MARK: Tap Queries
  

  //TODO: Redundant code. refactor to add object to filter and call main getTaps Method
  func tapsForObject(object: AnyObject, ofType type: ObjectType, completion: tapsCompletionHandler) {
    let tapQuery = PFQuery(className: "Tap")
    var queryToMatch = PFQuery()
    
    switch type {
    case .Brewery:
      queryToMatch = PFQuery(className: "Brewery")
      queryToMatch.whereKey("breweryId", equalTo: (object as! Brewery).breweryId)
      tapQuery.whereKey("brewery", matchesQuery: queryToMatch)
    case .Retailer:
      queryToMatch = PFQuery(className: "Retailer")
      queryToMatch.whereKey("retailerId", equalTo: (object as! Retailer).retailerId)
      tapQuery.whereKey("retailers", matchesQuery: queryToMatch)
    case .BeerStyle:
      queryToMatch = PFQuery(className: "Categories")
      queryToMatch.whereKey("categoryId", equalTo: (object as! BeerStyle).categoryId)
      tapQuery.whereKey("categories", matchesQuery: queryToMatch)
    default:
      break
    }
    
    tapQuery.includeKey("retailers")
    tapQuery.limit = kDefaultQueryLimit
    
    
    tapQuery.findObjectsInBackgroundWithBlock { (results, error) -> Void in
      dispatch_async(dispatch_get_main_queue()) {
        if let error = error {
          completion(taps: nil, error: error)
        }
        if let taps = results as? [Tap] {
          completion(taps: taps, error: nil)
        }
      }
    }
  }

  
  func loadMore(skipCount: Int, completion: ([PFObject]?, error: NSError?) -> Void) {
    if let currentQuery = currentQuery {
      currentQuery.skip = skipCount
      currentQuery.findObjectsInBackgroundWithBlock { (objects, error) in
        if let error = error {
          completion(nil, error: error)
        } else if let objects = objects {
          completion(objects, error: nil)
        }
      }
    } else {
      //TODO: pass custom error
      completion(nil, error: nil)
    }
  }
  
  //MARK: Retailer Queries
  
  func retailers(completion: retailersCompletionHandler) {
    let retailerQuery = PFQuery(className: "Retailer")
    
    //TODO hard code values
    retailerQuery.limit = kDefaultQueryLimit
    let maxDistanceInMiles = kDefaultQueryMaxDistance
    
    if !filter.tapIds.isEmpty {
      let tapQuery = PFQuery(className: "Tap")
      tapQuery.whereKey("beerId", containedIn: filter.tapIds)
      retailerQuery.whereKey("taps", matchesQuery: tapQuery)
    }
    
    if !filter.retailerIds.isEmpty {
      retailerQuery.whereKey("retailerId", containedIn: filter.retailerIds)
    }
    
    if !filter.categoryIds.isEmpty {
      let categoryQuery = BeerStyle.query()!
      categoryQuery.whereKey("categoryId", containedIn: filter.categoryIds)
      
      let tapQuery = Tap.query()!
      tapQuery.whereKey("categories", matchesQuery: categoryQuery)
      retailerQuery.whereKey("taps", matchesQuery: tapQuery)
    }
    
    if let currentGeoPoint = currentGeoPoint {
      retailerQuery.whereKey("coordinates", nearGeoPoint: currentGeoPoint, withinMiles: maxDistanceInMiles)
    }
    
    retailerQuery.findObjectsInBackgroundWithBlock { (retailers, error) in
      dispatch_async(dispatch_get_main_queue()) {
        if let error = error {
          completion(retailers: nil, error: error)
        } else if let retailers = retailers as? [Retailer] {
          completion(retailers: retailers, error: nil)
        }
      }
    }
  }
  
  //MARK: Brewery Queries
  
  func breweries(completion: breweriesCompletionHandler) {
    let breweryQuery = Brewery.query()!
    breweryQuery.whereKeyExists("taps")
    breweryQuery.limit = kDefaultQueryLimit
    
    if !filter.retailerIds.isEmpty {
      let retailerQuery = PFQuery(className: "Retailer")
      retailerQuery.whereKey("retailerId", containedIn: filter.retailerIds)
      
      let tapQuery = PFQuery(className: "Tap")
      tapQuery.whereKey("retailers", matchesQuery: retailerQuery)
      breweryQuery.whereKey("taps", matchesQuery: tapQuery)
    }
    
    if !filter.categoryIds.isEmpty {
      let categoryQuery = PFQuery(className: "Categories")
      categoryQuery.whereKey("categoryId", containedIn: filter.categoryIds)
      
      let tapQuery = PFQuery(className: "Tap")
      tapQuery.whereKey("categories", matchesQuery: categoryQuery)
      breweryQuery.whereKey("taps", matchesQuery: tapQuery)
    }
    
    if !filter.tapIds.isEmpty {
      let tapQuery = Tap.query()!
      tapQuery.whereKey("beerId", containedIn: filter.tapIds)
      breweryQuery.whereKey("taps", matchesQuery: tapQuery)
    }
    breweryQuery.orderByAscending("breweryName")
    
    if let currentGeoPoint = currentGeoPoint {
      let retailerQuery = PFQuery(className: "Retailer")
      retailerQuery.whereKey("coordinates", nearGeoPoint: currentGeoPoint, withinMiles: kDefaultQueryMaxDistance)
      let tapQuery = PFQuery(className: "Tap")
      tapQuery.whereKey("retailers", matchesQuery: retailerQuery)
      
      breweryQuery.whereKey("taps", matchesQuery: tapQuery)
    }
    
    breweryQuery.findObjectsInBackgroundWithBlock { (breweries, error) in
      dispatch_async(dispatch_get_main_queue()) {
        if let error = error {
          completion(breweries: nil, error: error)
        } else if let breweries = breweries as? [Brewery] {
          completion(breweries: breweries, error: nil)
        }
      }
    }
  }

  //TODO: Look into this method
  func breweriesForTap(tap: Tap, completion: breweriesCompletionHandler) {
    let breweryQuery = PFQuery(className: "Brewery")
    let tapQuery = PFQuery(className: "Tap")
    tapQuery.whereKey("beerId", equalTo: tap.beerId)
    tapQuery.includeKey("brewery")
    
    tapQuery.findObjectsInBackgroundWithBlock { (taps, error) in
      if let error = error {
        completion(breweries: nil, error: error)
      } else if let taps = taps as? [Tap] {
        let tap = taps[0]
        let brewery = tap["brewery"] as! Brewery
        
        completion(breweries: [brewery], error: nil)
      }
    }
  }

  //MARK: Category Queries
  
  func beerStyles(completionHandler: (beerStyles: [BeerStyle]?, error: NSError?) -> Void) {
    let styleQuery = PFQuery(className: "Categories")
    styleQuery.limit = kDefaultQueryLimit
    styleQuery.orderByAscending("categoryName")
    
    styleQuery.findObjectsInBackgroundWithBlock { (beerStyles, error) -> Void in
      NSOperationQueue.mainQueue().addOperationWithBlock {
        if let error = error {
          completionHandler(beerStyles: nil, error: error);
        } else if let beerStyles = beerStyles as? [BeerStyle] {
          completionHandler(beerStyles: beerStyles, error: nil)
        }
      }
    }
  }
}