//
//  DisplayImageService.swift
//  growlers
//
//  Created by Chris Budro on 10/13/15.
//  Copyright © 2015 chrisbudro. All rights reserved.
//

import UIKit
import AlamofireImage

let kDisplayImageFadeDuration = 0.4

class DisplayImageService {
  class func setImageView(imageView: UIImageView?, withUrlString urlString: String?, placeholderImage: UIImage?) {
    if let
      imageView = imageView {
        if let urlString = urlString,
          url = NSURL(string: urlString) {
            let size = imageView.frame.size
            let filter = AspectScaledToFillSizeFilter(size: size)
            
            imageView.af_setImageWithURL(url, placeholderImage: nil, filter: filter, imageTransition: .CrossDissolve(kDisplayImageFadeDuration))
        } else {
          imageView.contentMode = .ScaleAspectFit
          imageView.image = placeholderImage
        }
    }
  }
}
