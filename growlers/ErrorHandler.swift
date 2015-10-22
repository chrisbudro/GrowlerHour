//
//  ErrorHandler.swift
//  growlers
//
//  Created by Chris Budro on 10/4/15.
//  Copyright © 2015 chrisbudro. All rights reserved.
//

import Foundation



class ErrorHandler {
  class func errorWithMessage(message: String) -> NSError {
    let userInfo = [NSLocalizedDescriptionKey: message]
    let error = NSError(domain: kGrowlerErrorDomain, code: kGrowlerDefaultErrorCode, userInfo: userInfo)
    
    return error
  }
}