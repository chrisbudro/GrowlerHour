//
//  RetailerViewCell.swift
//  growlers
//
//  Created by Chris Budro on 5/1/15.
//  Copyright (c) 2015 chrisbudro. All rights reserved.
//

import UIKit
import Alamofire

let kMetersToMilesConversionMultiplier = 0.000621371

class RetailerViewCell: BaseTableViewCell {
  
  @IBOutlet weak var retailerNameLabel: UILabel!
  @IBOutlet weak var retailerAddressLabel: UILabel!
  @IBOutlet weak var distanceLabel: UILabel!
  @IBOutlet weak var numberOfTapsLabel: UILabel!
  @IBOutlet weak var retailerImageView: UIImageView!
  @IBOutlet weak var mainCanvasView: UIView!
  
  override var displayImage: UIImage? {
    get {
      return retailerImageView?.image
    }
    set {
      retailerImageView.image = newValue
    }
  }
  
  override func prepareForReuse() {
    retailerNameLabel.text = nil
    retailerAddressLabel.text = nil
    distanceLabel.text = nil
    numberOfTapsLabel.text = nil
    retailerImageView.image = nil
  }
  
  var request: Alamofire.Request?
  
  override func configureCellForObject(object: AnyObject) {
    if let retailer = object as? Retailer {
      
      retailerNameLabel.text = retailer.retailerName
      retailerAddressLabel.text = "\(retailer.streetAddress), \(retailer.city)"
      let beerOrBeers = retailer.taps.count == 1 ? "Beer" : "Beers"
      numberOfTapsLabel.text = "\(retailer.taps.count) \(beerOrBeers) on Tap"
      distanceLabel.text = retailer.distanceFromLocation != nil ? "\(retailer.distanceFromLocation!) mi" : ""
    }
  }
  
  override func setBackgroundShadow() {
    //Workaround while trying to solve issue with mainCanvasView sizing bug
    let bounds = CGRect(x: mainCanvasView.bounds.origin.x, y: mainCanvasView.bounds.origin.y, width: self.bounds.width - (kMainCanvasHorizontalPaddingConstraint * 2), height: self.bounds.height - (kMainCanvasVerticalPaddingConstraint * 2))
    let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: 2)
    mainCanvasView.layer.shadowPath = shadowPath.CGPath
    mainCanvasView.layer.shadowColor = UIColor.darkGrayColor().CGColor
    mainCanvasView.layer.shadowOffset = CGSizeMake(0, 1)
    mainCanvasView.layer.shadowOpacity = 0.4
    mainCanvasView.layer.shadowRadius = 2
    mainCanvasView.layer.cornerRadius = 2
  }
}
