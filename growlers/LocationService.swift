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
typealias GeoPointUpdateHandler = ((geoPoint: PFGeoPoint?, error: NSError?) -> Void)

class LocationService: NSObject, CLLocationManagerDelegate {
  
  //MARK: Singleton Instance
  static let shared = LocationService()
  
  //MARK: Constants
  let kDefaultLocationFetchTimer: NSTimeInterval = 20
  
  //MARK: Properties
  private var timeout: NSTimer?
  private var locationUpdateHandler: LocationUpdateHandler?
  private let locationManager = CLLocationManager()
  private var currentLocation: CLLocation? {
    willSet {
      let userInfo = [kNewLocationKey: newValue!]
      NSNotificationCenter.defaultCenter().postNotificationName(kLocationUpdatedNotification, object: nil, userInfo: userInfo)
    }
  }

  var locationDetails: LocationDetails?
  
  var currentLocationDetails: LocationDetails? {
    if let currentLocation = currentLocation {
      return (name: "Current Location", coordinate: currentLocation.coordinate)
    }
    return nil
  }
  
  var locationIsDirty = false
  var searchRadiusInMiles: Double = 50 {
    didSet {
      locationIsDirty = true
    }
  }
  
  //MARK: Initializer
  private override init() {
    super.init()
    locationManager.delegate = self
  }
  
  //MARK: Helper Methods
  func setSelectedLocation(locationDetails: LocationDetails) {
    self.locationDetails = locationDetails
    locationIsDirty = true
  }
  
  func setSelectedLocationToCurrentLocation() {
    if let currentLocationDetails = currentLocationDetails {
      locationDetails = currentLocationDetails
      locationIsDirty = true
    }
  }
  
  func setSearchRadius(searchRadius: Double) {
    searchRadiusInMiles = searchRadius
  }
  
  func selectedLocationIfAvailable(completion: LocationUpdateHandler) {
    if let locationDetails = locationDetails {
      completion(locationDetails: locationDetails, error: nil)
    } else {
      startMonitoringLocation { (locationDetails, error) -> Void in
        if let error = error {
          completion(locationDetails: nil, error: error)
        } else if let locationDetails = locationDetails {
          self.locationDetails = locationDetails
          completion(locationDetails: locationDetails, error: nil)
        }
      }
    }
  }
  
  func selectedGeoPointIfAvailable(completion: GeoPointUpdateHandler) {
    selectedLocationIfAvailable() { (locationDetails, error) in
      if let error = error {
        completion(geoPoint: nil, error: error)
      } else if let locationDetails = locationDetails {
        let lat = locationDetails.coordinate.latitude
        let long = locationDetails.coordinate.longitude
        let geoPoint = PFGeoPoint(latitude: lat, longitude: long)
        completion(geoPoint: geoPoint, error: nil)
      }
    }
  }
  
  func startMonitoringLocation(completion: LocationUpdateHandler?) {
    let servicesDisabledError = ErrorHandler.errorWithMessage("Location Services is required to filter by proximity.  Please enable Location Services in the Settings app or select a manual location in the filter settings")
    
    if SimulatorCheck.isSimulator {
      completion?(locationDetails: kDefaultLocationDetails, error: nil)
    } else {
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
          timeout = NSTimer.scheduledTimerWithTimeInterval(kDefaultLocationFetchTimer, target: self, selector: "locationFetchTimedOut", userInfo: nil, repeats: false)

          locationManager.stopMonitoringSignificantLocationChanges()
          locationManager.startMonitoringSignificantLocationChanges()
        }
      } else {
        completion?(locationDetails: nil, error: servicesDisabledError)
      }
    }
  }
  
  private func locationFetchTimedOut() {
    let error = ErrorHandler.errorWithMessage("We were unable to retrieve your current location.  Please manually enter a location or try again later")
    locationUpdateHandler?(locationDetails: nil, error: error)
    locationUpdateHandler = nil
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
      timeout?.invalidate()
    }
  }
  
  func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
    locationUpdateHandler?(locationDetails: nil, error: error)
    timeout?.invalidate()
  }
}
