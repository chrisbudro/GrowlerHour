//
//  BreweryViewCell.swift
//  growlers
//
//  Created by Chris Budro on 4/22/15.
//  Copyright (c) 2015 chrisbudro. All rights reserved.
//

import UIKit
import Alamofire

class BreweryViewCell: UITableViewCell {
  
  @IBOutlet weak var breweryNameLabel: UILabel!
  @IBOutlet weak var homeTownLabel: UILabel!
  @IBOutlet weak var logoImageView: UIImageView!
  @IBOutlet weak var numberOfTapsLabel: UILabel!
  @IBOutlet weak var mainCanvasView: UIView!

  override func prepareForReuse() {
    super.prepareForReuse()
    
    breweryNameLabel.text = nil
    homeTownLabel.text = nil
    numberOfTapsLabel.text = nil
    logoImageView.af_cancelImageRequest()
    logoImageView.image = nil
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    mainCanvasView.setBackgroundShadow()
  }
}

extension BreweryViewCell: ConfigurableCell {
  func configureCellForObject(object: AnyObject) {
    if let brewery = object as? Brewery {
      breweryNameLabel.text = brewery.breweryName
      if let
        city = brewery.city,
        state = brewery.state {
          let separator = !city.isEmpty && !state.isEmpty ? ", " : ""
          homeTownLabel.text = "\(city)\(separator)\(state)"
      }
      
//      let beerOrBeers = brewery.taps.count == 1 ? "Beer" : "Beers"
//      numberOfTapsLabel.text = "\(brewery.taps.count) \(beerOrBeers) on Tap"
      
      DisplayImageService.setImageView(logoImageView, withUrlString: brewery.imageUrl, placeholderImage: UIImage(named: "growlerIcon"))
    }
  }
}
