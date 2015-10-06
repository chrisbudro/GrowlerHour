//
//  BeerViewswift
//  growlers
//
//  Created by Chris Budro on 4/21/15.
//  Copyright (c) 2015 chrisbudro. All rights reserved.
//

import UIKit
import Alamofire

class BeerViewCell: BaseTableViewCell {

  @IBOutlet weak var breweryLabel: UILabel!
  @IBOutlet weak var beerTitleLabel: UILabel!
  @IBOutlet weak var beerStyleLabel: UILabel!
  @IBOutlet weak var beerImageView: UIImageView!
  @IBOutlet weak var abvTextLabel: UILabel!
  @IBOutlet weak var ibuTextLabel: UILabel!
  @IBOutlet weak var mainCanvasView: UIView!
  
  var request: Alamofire.Request?

  override func prepareForReuse() {
    breweryLabel.text = nil
    beerTitleLabel.text = nil
    beerStyleLabel.text = nil
    abvTextLabel.text = nil
    ibuTextLabel.text = nil
    beerImageView.image = nil
  }
  
  override func configureCellForObject(object: AnyObject) {
    if let tap = object as? Tap {
      
      breweryLabel.text = tap.breweryName
      beerTitleLabel.text = tap.beerTitle
      beerStyleLabel.text = tap.beerStyle
      
      let separator = tap.abv != 0 ? "/ " : ""
      abvTextLabel.text = tap.abv != 0 ? "\(tap.abv) ABV" : ""
      ibuTextLabel.text = tap.ibu != 0 ? "\(separator)\(tap.ibu) IBU" : ""
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
