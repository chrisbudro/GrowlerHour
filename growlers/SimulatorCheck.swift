//
//  SimulatorCheck.swift
//  growlers
//
//  Created by Chris Budro on 10/23/15.
//  Copyright © 2015 chrisbudro. All rights reserved.
//

import Foundation

struct SimulatorCheck {
  static let isSimulator: Bool = {
    var isSim = false
    #if arch(i386) || arch(x86_64)
      isSim = true
    #endif
    return isSim
  }()
}