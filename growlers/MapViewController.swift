//
//  MapViewController.swift
//  GrowlerHour
//
//  Created by Chris Budro on 11/1/15.
//  Copyright © 2015 chrisbudro. All rights reserved.
//

import UIKit

class MapViewController: UIViewController {
  
  //MARK: Constants
  let kMapPadding: CGFloat = 10
  
  //MARK: Properties
  private var mapView: GMSMapView!
  var markers = [GMSMarker]()

  //MARK: Life Cycle Methods
  override func loadView() {
    super.loadView()
    
    mapView = GMSMapView(frame: view.frame)
    view.addSubview(mapView)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    mapView.delegate = self
    
    addMarkersToMap()
    centerCameraOnMarkers()
  }
  
  //MARK: Helper Methods
  func addMarkersToMap() {
    for marker in markers {
      marker.map = mapView
    }
  }
  
  func centerCameraOnMarkers() {
    let path = GMSMutablePath()
    for marker in markers {
      path.addCoordinate(marker.position)
    }
    let bounds = GMSCoordinateBounds(path: path)
    let camera = mapView.cameraForBounds(bounds, insets: UIEdgeInsets(top: kMapPadding, left: kMapPadding, bottom: kMapPadding, right: kMapPadding))
    mapView.animateToCameraPosition(camera)
  }
}

extension MapViewController: GMSMapViewDelegate {
  
}

