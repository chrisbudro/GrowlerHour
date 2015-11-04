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
  
  //MARK: Outlets
  @IBOutlet weak var retailerNameLabel: UILabel!
  @IBOutlet weak var retailerAddressLabel: UILabel!
  @IBOutlet weak var distanceLabel: UILabel!
  @IBOutlet weak var numberOfTapsLabel: UILabel!
  @IBOutlet weak var retailerImageView: UIImageView!
  @IBOutlet weak var mainCanvasView: UIView!
  
  //MARK: Life Cycle Methods
  override func prepareForReuse() {
    super.prepareForReuse()
    
    retailerNameLabel.text = nil
    retailerAddressLabel.text = nil
    distanceLabel.text = nil
    numberOfTapsLabel.text = nil
    retailerImageView.af_cancelImageRequest()
    retailerImageView.image = nil
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    mainCanvasView.setBackgroundShadow()
  }
}

//MARK: Configurable Cell
extension RetailerViewCell: ConfigurableCell {
  func configureCellForObject(object: AnyObject) {
    
    if let retailer = object as? Retailer {
      retailerNameLabel.text = retailer.retailerName
      retailerAddressLabel.text = "\(retailer.streetAddress), \(retailer.city)"
      retailer.distanceFromSelectedLocation({ (distance, error) -> Void in
        if let distance = distance {
          self.distanceLabel.text = "\(distance) mi"
        }
      })
      
      DisplayImageService.setImageView(retailerImageView, withUrlString: retailer.photo?.url, placeholderImage: UIImage(named: "GrowlerPlaceholder"))
    }
  }
}
