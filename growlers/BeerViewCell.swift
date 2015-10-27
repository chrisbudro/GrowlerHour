//
//  BeerViewswift
//  growlers
//
//  Created by Chris Budro on 4/21/15.
//  Copyright (c) 2015 chrisbudro. All rights reserved.
//

import UIKit
import Alamofire

class BeerViewCell: UITableViewCell {

  //MARK: Outlets
  @IBOutlet weak var breweryLabel: UILabel!
  @IBOutlet weak var beerTitleLabel: UILabel!
  @IBOutlet weak var beerStyleLabel: UILabel!
  @IBOutlet weak var beerImageView: UIImageView!
  @IBOutlet weak var abvTextLabel: UILabel!
  @IBOutlet weak var ibuTextLabel: UILabel!
  @IBOutlet weak var mainCanvasView: UIView!
  
  //MARK: Life Cycle Methods
  override func prepareForReuse() {
    super.prepareForReuse()
    
    breweryLabel.text = nil
    beerTitleLabel.text = nil
    beerStyleLabel.text = nil
    abvTextLabel.text = nil
    ibuTextLabel.text = nil
    beerImageView.af_cancelImageRequest()
    beerImageView.image = nil
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    mainCanvasView.setBackgroundShadow()
  }
}

//MARK: Configurable Cell
extension BeerViewCell: ConfigurableCell {
  func configureCellForObject(object: AnyObject) {
    if let tap = object as? Tap {
      
      breweryLabel.text = tap.breweryName
      beerTitleLabel.text = tap.beerTitle
      beerStyleLabel.text = tap.beerStyle
      
      let separator = tap.abv != 0 ? "/ " : ""
      abvTextLabel.text = tap.abv != 0 ? "\(tap.abv) ABV" : ""
      ibuTextLabel.text = tap.ibu != 0 ? "\(separator)\(tap.ibu) IBU" : ""
      
      DisplayImageService.setImageView(beerImageView, withUrlString: tap.imageUrl, placeholderImage: UIImage(named: "growlerIcon"))
    }
  }
}
