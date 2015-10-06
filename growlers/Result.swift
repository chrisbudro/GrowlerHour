//
//  Result.swift
//  growlers
//
//  Created by Chris Budro on 9/20/15.
//  Copyright © 2015 chrisbudro. All rights reserved.
//

import Foundation

enum Result {
  case Success([Tap])
  case Failure(String)
}