//
//  UIView+BackgroundShadow.swift
//  growlers
//
//  Created by Chris Budro on 10/16/15.
//  Copyright © 2015 chrisbudro. All rights reserved.
//

import Foundation

extension UIView {
    func setBackgroundShadow() {
      self.setNeedsLayout()
      self.layoutIfNeeded()
      
      let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: 2)
      self.layer.shadowPath = shadowPath.CGPath
      self.layer.shadowColor = UIColor.darkGrayColor().CGColor
      self.layer.shadowOffset = CGSizeMake(0, 1)
      self.layer.shadowOpacity = 0.4
      self.layer.shadowRadius = 2
      self.layer.cornerRadius = 2
    }
}