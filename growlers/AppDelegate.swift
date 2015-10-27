//
//  AppDelegate.swift
//  growlers
//
//  Created by Mac Pro on 4/10/15.
//  Copyright (c) 2015 chrisbudro. All rights reserved.
//

import UIKit
import Parse

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?

  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    //MARK: Location Service Setup
    LocationService.shared.startMonitoringLocation(nil)

    //MARK: Google Setup
    GMSServices.provideAPIKey(kGooglePlacesKey)
    
    //MARK: Parse Setup
    Tap.registerSubclass()
    BeerStyle.registerSubclass()
    Retailer.registerSubclass()
    Brewery.registerSubclass()
    
    Parse.setApplicationId(kParseAppID,
      clientKey: kParseClientKey)
    
    //MARK: Push Setup
    let userNotificationTypes: UIUserNotificationType = ([UIUserNotificationType.Alert, UIUserNotificationType.Sound, UIUserNotificationType.Badge])
    let settings = UIUserNotificationSettings(forTypes: userNotificationTypes, categories: nil)
    application.registerUserNotificationSettings(settings)
    application.registerForRemoteNotifications()
    
    //MARK: Appearance
    UITableView.appearance().backgroundColor = UIColor.lightGrayColor()
    BeerViewCell.appearance().backgroundColor = UIColor.clearColor()
    BreweryViewCell.appearance().backgroundColor = UIColor.clearColor()
    UINavigationBar.appearance().barTintColor = UIColor.darkGrayColor()
    UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
    UITabBar.appearance().barTintColor = UIColor(white: 0.2, alpha: 0.9)
    UINavigationBar.appearance().tintColor = UIColor.whiteColor()
    UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffsetMake(0, -60), forBarMetrics: .Default)
    UITableViewCell.appearance().textLabel?.textColor = UIColor.whiteColor()
    UITabBar.appearance().tintColor = UIColor(white: 0.9, alpha: 1.0)
    UITableView.appearance().separatorStyle = .None
    let titleAttributes = [NSFontAttributeName: UIFont(name: "HelveticaNeue", size: 13.0)!, NSForegroundColorAttributeName: UIColor.whiteColor()]
    UIBarButtonItem.appearance().setTitleTextAttributes(titleAttributes, forState: UIControlState.Normal)
    return true
    
  }
  
  func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
    let currentInstallation = PFInstallation.currentInstallation()
    currentInstallation.setDeviceTokenFromData(deviceToken)
    currentInstallation.saveInBackground()
  }
  
  func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
    PFPush.handlePush(userInfo)
  }
}

