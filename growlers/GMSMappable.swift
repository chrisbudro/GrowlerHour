//
//  GMSMappable.swift
//  GrowlerHour
//
//  Created by Chris Budro on 11/3/15.
//  Copyright © 2015 chrisbudro. All rights reserved.
//

import Foundation
import GoogleMaps

protocol GMSMappable {
  var mapMarker: GMSMarker {get}
}