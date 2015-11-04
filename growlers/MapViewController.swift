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
  let mapPadding: CGFloat = 10
  
  //MARK: Properties
  private var mapView: GMSMapView!
  var objects = [GMSMappable]()

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
    for object in objects {
      object.mapMarker.map = mapView
    }
  }
  
  func centerCameraOnMarkers() {
    let path = GMSMutablePath()
    for object in objects {
      path.addCoordinate(object.mapMarker.position)
    }
    let bounds = GMSCoordinateBounds(path: path)
    let camera = mapView.cameraForBounds(bounds, insets: UIEdgeInsets(top: mapPadding, left: mapPadding, bottom: mapPadding, right: mapPadding))
    mapView.animateToCameraPosition(camera)
  }
}

extension MapViewController: GMSMapViewDelegate {
  
}

