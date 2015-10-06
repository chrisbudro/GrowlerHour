//
//  TapListDownloader.swift
//  growlers
//
//  Created by Mac Pro on 4/10/15.
//  Copyright (c) 2015 chrisbudro. All rights reserved.
//

import Foundation

class TapListDownloader: NSObject {
    
    private let apiKey = "apikey=4LPCQWTu7Ocf7CioJ1CEaIA1CnwCPbFn"
    private let baseURL = "https://www.kimonolabs.com/api/6p1x13vk?"
    
    func getTapList(completion: (tapList: [Tap]) -> Void) {
    
    let urlModifier = "&kimmodify=1"
    let requestURL = NSURL(string: baseURL + apiKey + urlModifier)
    let session = NSURLSession.sharedSession()
    let downloadTask : NSURLSessionDownloadTask = session.downloadTaskWithURL(requestURL!, completionHandler: { (tapList, response, error) -> Void in
        let data = NSData(contentsOfURL: tapList, options: nil, error: nil)
    
        if let
            JSON = NSJSONSerialization.JSONObjectWithData(data!, options: nil, error: nil) as? NSDictionary,
            results = JSON["results"] as? NSDictionary,
            tapListJSON = results["location"] as? NSArray
        {
            let tapList = self.makeTaps(tapListJSON)
            completion(tapList: tapList)
        }
    })
    
    downloadTask.resume()

    }
    
    func makeTaps(tapListJSON: NSArray) -> [Tap] {
    
        var tapList : [Tap] = []
        for tap in tapListJSON {
            
            if let
                tapJSON = tap as? NSDictionary,
                retailerName = tapJSON["retailerName"] as? String,
                beerName = tapJSON["beerName"] as? String,
                beerStyle = tapJSON["beerStyle"] as? String,
                brewery = tapJSON["brewery"] as? String,
                homeTown = tapJSON["homeTown"] as? String
            {
            let tap = Tap(
                retailerName: retailerName,
                beerName: beerName,
                beerStyle: beerStyle,
                brewery: brewery
                )
                
                tapList.append(tap)
            }

        }
       return tapList
    }
    
    
}
