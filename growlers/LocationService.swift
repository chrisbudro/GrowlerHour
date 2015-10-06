//
//  LocationService.swift
//  growlers
//
//  Created by Chris Budro on 9/20/15.
//  Copyright © 2015 chrisbudro. All rights reserved.
//

import Foundation
import CoreLocation
import Parse

typealias LocationUpdateHandler = ((locationDetails: LocationDetails?, error: NSError?) -> Void)

class LocationService: NSObject, CLLocationManagerDelegate {
  
  static let shared = LocationService()
  
  private var locationUpdateHandler: LocationUpdateHandler?
  let locationManager = CLLocationManager()
  private(set) var currentLocation: CLLocation? {
    willSet {
      let userInfo = [kNewLocationKey: newValue!]
      NSNotificationCenter.defaultCenter().postNotificationName(kLocationUpdatedNotification, object: nil, userInfo: userInfo)
    }
  }
  var currentGeoPoint: PFGeoPoint? {
    if let currentLocation = currentLocation {
      return PFGeoPoint(location: currentLocation)
    }
    return nil
  }
  
  var locationDetails: LocationDetails? {
    if let currentLocation = currentLocation {
      return (name: "Current Location", coordinate: currentLocation.coordinate)
    }
    return nil
  }
  
  private override init() {
    super.init()
    locationManager.delegate = self
  }
  
  func startMonitoringLocation(completion: LocationUpdateHandler?) {
    let userInfo = [NSLocalizedDescriptionKey: "Location Services is required to filter by proximity.  Please enable Location Services in the Settings app or select a manual location in the filter settings"]
    let servicesDisabledError = NSError(domain: kGrowlerErrorDomain, code: kGrowlerDefaultErrorCode, userInfo: userInfo)
    
    if CLLocationManager.significantLocationChangeMonitoringAvailable() && CLLocationManager.locationServicesEnabled() {
      if (CLLocationManager.authorizationStatus() != .AuthorizedAlways) {
        locationUpdateHandler = completion
        locationManager.requestAlwaysAuthorization()
      }
      else if (CLLocationManager.authorizationStatus() == .Restricted ||
        CLLocationManager.authorizationStatus() == .Denied )
      {
        completion?(locationDetails: nil, error: servicesDisabledError)
      }
      else
      {
        locationUpdateHandler = completion
        
        locationManager.stopMonitoringSignificantLocationChanges()
        locationManager.startMonitoringSignificantLocationChanges()
      }
    } else {
      completion?(locationDetails: nil, error: servicesDisabledError)
    }
  }
  
  //MARK: Core Location Manager Delegate
  
  
  func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
    
    if (status == .AuthorizedAlways || status == .AuthorizedWhenInUse) {
      manager.startMonitoringSignificantLocationChanges()
    }
  }
  
  func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    if let location = locations.last {
      currentLocation = location
      locationUpdateHandler?(locationDetails: locationDetails, error: nil)
    }
  }
  
  func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
    locationUpdateHandler?(locationDetails: nil, error: error)
  }
}
