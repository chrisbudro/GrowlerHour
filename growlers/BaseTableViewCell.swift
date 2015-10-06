//
//  BaseTableViewCell.swift
//  growlers
//
//  Created by Chris Budro on 9/8/15.
//  Copyright (c) 2015 chrisbudro. All rights reserved.
//

import UIKit
import Alamofire

class BaseTableViewCell: UITableViewCell {
  
  let kMainCanvasHorizontalPaddingConstraint: CGFloat = 8
  let kMainCanvasVerticalPaddingConstraint: CGFloat = 4
  
  var displayImage: UIImage? {
    get {
      return self.imageView?.image
    }
    set {
      self.imageView?.image = newValue
    }
  }
  
  var imageRequest: Alamofire.Request?

  func configureCellForObject(object: AnyObject) {
    
  }
  
  func setBackgroundShadow() {

  }
}
