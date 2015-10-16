//
//  Category.swift
//  growlers
//
//  Created by Chris Budro on 5/14/15.
//  Copyright (c) 2015 chrisbudro. All rights reserved.
//

import Foundation
import Parse

class BeerStyle: PFObject {
  
  @NSManaged var categoryName: String
  @NSManaged var categoryId: String

}

extension BeerStyle: PFSubclassing {
  static func parseClassName() -> String {
    return kBeerStyleParseClassName
  }
}

extension BeerStyle: Filterable {
  var id: String {
    return categoryId
  }
}

