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
    LocationService.shared.startMonitoringLocation(nil)

    GMSServices.provideAPIKey(kGooglePlacesKey)
    
    
    Tap.registerSubclass()
    BeerStyle.registerSubclass()
    Retailer.registerSubclass()
    Brewery.registerSubclass()
    
    Parse.setApplicationId(kParseAppID,
      clientKey: kParseClientKey)
    
    let userNotificationTypes: UIUserNotificationType = ([UIUserNotificationType.Alert, UIUserNotificationType.Sound, UIUserNotificationType.Badge])
    let settings = UIUserNotificationSettings(forTypes: userNotificationTypes, categories: nil)
    application.registerUserNotificationSettings(settings)
    application.registerForRemoteNotifications()
    
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
    currentInstallation.saveInBackgroundWithBlock { (isSaved: Bool, error: NSError?) -> Void in
      if (!isSaved) {
        print(error)
      }
    }
  }
  
  func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
    print(userInfo)
    PFPush.handlePush(userInfo)
  }
  
  
  func applicationWillResignActive(application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
  }
  
  func applicationDidEnterBackground(application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }
  
  func applicationWillEnterForeground(application: UIApplication) {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
  }
  
  func applicationDidBecomeActive(application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }
  
  func applicationWillTerminate(application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }
  
  
}

