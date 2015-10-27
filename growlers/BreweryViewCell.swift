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
  
  //MARK: Outlets
  @IBOutlet weak var breweryNameLabel: UILabel!
  @IBOutlet weak var homeTownLabel: UILabel!
  @IBOutlet weak var logoImageView: UIImageView!
  @IBOutlet weak var numberOfTapsLabel: UILabel!
  @IBOutlet weak var mainCanvasView: UIView!

  //MARK: Life Cycle Methods
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

//MARK: Configurable Cell
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

      DisplayImageService.setImageView(logoImageView, withUrlString: brewery.imageUrl, placeholderImage: UIImage(named: "growlerIcon"))
    }
  }
}
