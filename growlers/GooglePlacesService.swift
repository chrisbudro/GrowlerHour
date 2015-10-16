//
//  GooglePlaceService.swift
//  growlers
//
//  Created by Chris Budro on 10/4/15.
//  Copyright © 2015 chrisbudro. All rights reserved.
//

import Foundation

//typealias AutocompleteResult = GMSAutocompletePrediction

class GooglePlacesService {
  class func autocompleteResultsFromSearchTerm(searchTerm: String?, completion: (predictions: [GMSAutocompletePrediction]?, error: NSError?) -> Void) {
    let placesClient = GMSPlacesClient.sharedClient()
    
    if let searchTerm = searchTerm {
      placesClient.autocompleteQuery(searchTerm, bounds: nil, filter: nil) { (predictions, error) in
        if let error = error {
          completion(predictions: nil, error: error)
        } else if let predictions = predictions as? [GMSAutocompletePrediction] {
          completion(predictions: predictions, error: nil)
        }
      }
    } else {
      completion(predictions: nil, error: nil)
    }
  }
  
  class func detailsForPrediction(prediction: GMSAutocompletePrediction, completion: (locationDetails: LocationDetails?, error: NSError?) -> Void) {
    let placesClient = GMSPlacesClient.sharedClient()
    
    let placeID = prediction.placeID
    placesClient.lookUpPlaceID(placeID) { (place, error) in
      if let _ = error {
        let loadError = ErrorHandler.errorWithMessage("There was a problem loading the selected location.  Please try again")
        completion(locationDetails: nil, error: loadError)
      } else if let place = place {
        let locationDetails = LocationDetails(name: place.name, coordinate: place.coordinate)
        completion(locationDetails: locationDetails, error: nil)
      }
    }
  }
}