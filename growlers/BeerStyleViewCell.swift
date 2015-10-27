//
//  CategoryViewCell.swift
//  growlers
//
//  Created by Mac Pro on 5/7/15.
//  Copyright (c) 2015 chrisbudro. All rights reserved.
//

import UIKit

class BeerStyleViewCell: UITableViewCell {
  
  //MARK: Outlets
  @IBOutlet weak var categoryNameLabel: UILabel!
  @IBOutlet weak var numberOfTapsLabel: UILabel!
  @IBOutlet weak var mainCanvasView: UIView!
  
}

//MARK: Configurable Cell
extension BeerStyleViewCell: ConfigurableCell {
  func configureCellForObject(object: AnyObject) {
    if let beerStyle = object as? BeerStyle {
      
      categoryNameLabel.text = beerStyle.categoryName
    }
  }
}
