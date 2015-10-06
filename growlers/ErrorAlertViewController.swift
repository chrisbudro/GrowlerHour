//
//  ErrorAlertViewController.swift
//  growlers
//
//  Created by Chris Budro on 9/20/15.
//  Copyright © 2015 chrisbudro. All rights reserved.
//

import Foundation

class ErrorAlertController {
  class func alertControllerWithError(error: NSError) -> UIAlertController {
    let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .Alert)
    alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
    
    return alert
  }
}