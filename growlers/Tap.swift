//
//  Tap.swift
//  growlers
//
//  Created by Mac Pro on 4/10/15.
//  Copyright (c) 2015 chrisbudro. All rights reserved.
//

import Foundation
import Parse

class Tap: PFObject {
  
  override var description : String {
    return "\(beerTitle), \(beerStyle)"
  }
  
  @NSManaged var beerTitle : String
  @NSManaged var beerStyle : String
  @NSManaged var breweryName : String
  @NSManaged var brewery: Brewery
  @NSManaged var beerId: Int
  @NSManaged var retailers: [Retailer]
  @NSManaged var abv : Double
  @NSManaged var ibu : Int
  @NSManaged var beerDescription: String?
  @NSManaged var imageUrl: String?
  @NSManaged var dateCreated: NSDate?
  
}

extension Tap: PFSubclassing {
  static func parseClassName() -> String {
    return kTapParseClassName
  }
}

extension Tap: Filterable {
  var id: String {
    return "\(beerId)"
  }
}





