//
//  MapViewExtension.swift
//  GrowlerHour
//
//  Created by Chris Budro on 11/1/15.
//  Copyright © 2015 chrisbudro. All rights reserved.
//

import Foundation

extension MapViewController {
  func mapView(mapView: GMSMapView!, didTapInfoWindowOfMarker marker: GMSMarker!) {
    if let retailer = marker.userData as? Retailer {
      let retailerDetailVC = RetailerDetailViewController()
      retailerDetailVC.retailer = retailer
      navigationController?.pushViewController(retailerDetailVC, animated: true)
    }
  }
}