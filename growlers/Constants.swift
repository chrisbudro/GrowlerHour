//
//  Constants.swift
//  growlers
//
//  Created by Chris Budro on 6/16/15.
//  Copyright (c) 2015 chrisbudro. All rights reserved.
//

import Foundation

let kFollowedBreweries = "followedBreweries"
let kFollowedRetailers = "followedRetailers"
let kFollowedBeers = "followedBeers"
let kFollowedCategories = "followedCategories"

let kNotificationBreweries = "pushBreweries"
let kNotificationRetailers = "pushRetailers"
let kNotificationBeers = "pushBeers"
let kNotificationCategories = "pushCategories"

let kEstimatedCellHeight: CGFloat = 100
let kBreweryCellReuseIdentifier = "BreweryCell"
let kStyleCellReuseIdentifier = "BeerStyleCell"
let kRetailerCellReuseIdentifier = "RetailerCell"
let kTapCellReuseIdentifier = "TapCell"

let kBeerStyleParseClassName = "Categories"
let kBreweryParseClassName = "Brewery"
let kRetailerParseClassName = "Retailer"
let kTapParseClassName = "Tap"

let kBeerStyleNibName = "BeerStyleViewCell"
let kBreweryNibName = "BreweryViewCell"
let kTapNibName = "TapViewCell"
let kRetailerNibName = "RetailerViewCell"
let kFilterHeaderNibName = "FilterHeaderCell"

let kFilterHeaderCellReuseIdentifier = "FilterHeaderCell"

let kNewLocationKey = "NewLocationKey"
let kLocationUpdatedNotification = "LocationUpdated"

let kFilterIsDirtyNotification = "FilterIsDirty"

let kGrowlerErrorDomain = "com.chrisbudro.GrowlerHour"
let kGrowlerDefaultErrorCode = 1


//MARK: Parse Query Keys

let kParseTapIdKey = "beerId"
let kParseBeerStyleIdKey = "categoryId"
let kParseRetailerIdKey = "retailerId"
let kParseTapAbvKey = "abv"
let kParseTapIbuKey = "ibu"
let kParseBreweryIdKey = "breweryId"
let kParseImageUrlKey = "imageUrl"

let kParseRetailerClassName = "Retailer"
let kParseBreweryClassName = "Brewery"
let kParseTapClassName = "Tap"
let kParseStyleGroupClassName = "Categories"

let kParseMiscTapStylesObjectId = "Go0XwcsbTo"
let kParseCiderTapStyleObjectId = "Ram0dmMRPd"



let kParseTapsRelationKey = "taps"
let kParseStyleGroupRelationKey = "categories"
let kParseGeoPointKey = "coordinates"
let kParseRetailersRelationKey = "retailers"
let kParseBreweryRelationKey = "brewery"


//MARK: UI Constants

let kCellShadowHorizontalPaddingConstraint: CGFloat = 8
let kCellShadowVerticalPaddingConstraint: CGFloat = 4


