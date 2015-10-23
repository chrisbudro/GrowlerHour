//
//  RetailerViewCell.swift
//  growlers
//
//  Created by Chris Budro on 5/1/15.
//  Copyright (c) 2015 chrisbudro. All rights reserved.
//

import UIKit

let kMetersToMilesConversionMultiplier = 0.000621371

class RetailerViewCell: UITableViewCell {
  
  @IBOutlet weak var retailerNameLabel: UILabel!
  @IBOutlet weak var retailerAddressLabel: UILabel!
  @IBOutlet weak var distanceLabel: UILabel!
  @IBOutlet weak var numberOfTapsLabel: UILabel!
  @IBOutlet weak var retailerImageView: UIImageView!
  @IBOutlet weak var mainCanvasView: UIView!
  
  override func prepareForReuse() {
    super.prepareForReuse()
    
    retailerNameLabel.text = nil
    retailerAddressLabel.text = nil
    distanceLabel.text = nil
    numberOfTapsLabel.text = nil
    retailerImageView.af_cancelImageRequest()
    retailerImageView.image = nil
  }
}

extension RetailerViewCell: ConfigurableCell {
  func configureCellForObject(object: AnyObject) {
    mainCanvasView.setBackgroundShadow()
    
    if let retailer = object as? Retailer {
      retailerNameLabel.text = retailer.retailerName
      retailerAddressLabel.text = "\(retailer.streetAddress), \(retailer.city)"
//      let beerOrBeers = retailer.taps.count == 1 ? "Beer" : "Beers"
//      numberOfTapsLabel.text = "\(retailer.taps.count) \(beerOrBeers) on Tap"
      distanceLabel.text = retailer.distanceFromLocation != nil ? "\(retailer.distanceFromLocation!) mi" : ""
      
      DisplayImageService.setImageView(retailerImageView, withUrlString: retailer.photo?.url, placeholderImage: UIImage(named: "growlerIcon"))
    }
  }
}
