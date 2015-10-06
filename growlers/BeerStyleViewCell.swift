//
//  CategoryViewCell.swift
//  growlers
//
//  Created by Mac Pro on 5/7/15.
//  Copyright (c) 2015 chrisbudro. All rights reserved.
//

import UIKit

class BeerStyleViewCell: BaseTableViewCell {
  
  
  @IBOutlet weak var categoryNameLabel: UILabel!
  @IBOutlet weak var numberOfTapsLabel: UILabel!
  @IBOutlet weak var mainCanvasView: UIView!
  
  override func configureCellForObject(object: AnyObject) {
    if let beerStyle = object as? BeerStyle {
      //        setBackgroundShadow()
      
      categoryNameLabel.text = beerStyle.categoryName
      
      //        let beerOrBeers = beerStyle.taps.count == 1 ? "Beer" : "Beers"
      //        numberOfTapsLabel.text = "\(beerStyle.taps.count) \(beerOrBeers) on tap"
    }
  }
  
  override func setBackgroundShadow() {

  }
}
