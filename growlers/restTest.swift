//
//  restTest.swift
//  growlers
//
//  Created by Chris Budro on 5/13/15.
//  Copyright (c) 2015 chrisbudro. All rights reserved.
//
//
//import Foundation
//
//func makeParseRequest(searchString: String) {
//    
//    var request = NSMutableURLRequest()
//    request.HTTPMethod = "GET"
//    request.addValue(kAppId, forHTTPHeaderField: "X-Parse-Application-Id")
//    request.addValue(kRestAPIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
//    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//    request.addValue("application/json", forHTTPHeaderField: "Accept")
//    
//    var params = ["Query1" : "\(searchString)"]
//    var error: NSError?
//    var paramsJSON = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &error)
//    var paramsJSONString = NSString(data: paramsJSON!, encoding: NSUTF8StringEncoding)
//    var whereClause = paramsJSONString?.stringByAddingPercentEscapesUsingEncoding(NSASCIIStringEncoding)
//    
//    let urlString = "https://api.parse.com/1/classes/sampleObjectData"
//    var requestURL = NSURL(string: String(format: "%@?%@%@", urlString, "where=", whereClause!))
//    
//    request.URL = requestURL!
//    
//    var task = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data, response, err) -> Void in
//        var stringData = NSString(data: data, encoding: NSUTF8StringEncoding)
//        println(stringData)
//    })
//    
//    task.resume()
//}