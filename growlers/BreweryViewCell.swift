//
//  BreweryViewCell.swift
//  growlers
//
//  Created by Chris Budro on 4/22/15.
//  Copyright (c) 2015 chrisbudro. All rights reserved.
//

import UIKit
import Alamofire

class BreweryViewCell: BaseTableViewCell {
  
  @IBOutlet weak var breweryNameLabel: UILabel!
  @IBOutlet weak var homeTownLabel: UILabel!
  @IBOutlet weak var logoImageView: UIImageView!
  @IBOutlet weak var numberOfTapsLabel: UILabel!
  @IBOutlet weak var mainCanvasView: UIView!
  
  var request: Alamofire.Request?
  
  override var displayImage: UIImage? {
    get {
      return logoImageView?.image
    }
    set {
      logoImageView.image = newValue
    }
  }
  
  override func prepareForReuse() {
    breweryNameLabel.text = nil
    homeTownLabel.text = nil
    numberOfTapsLabel.text = nil
    logoImageView.image = nil
  }
  
  override func configureCellForObject(object: AnyObject) {
    if let brewery = object as? Brewery {
      
      breweryNameLabel.text = brewery.breweryName
      if let
        city = brewery.city,
        state = brewery.state {
          let separator = !city.isEmpty && !state.isEmpty ? ", " : ""
          homeTownLabel.text = "\(city)\(separator)\(state)"
      }
      
      let beerOrBeers = brewery.taps.count == 1 ? "Beer" : "Beers"
      numberOfTapsLabel.text = "\(brewery.taps.count) \(beerOrBeers) on Tap"
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
