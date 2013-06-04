//
//  MTConstants.h
//  Rain
//
//  Created by Bart Jacobs on 10/05/13.
//  Copyright (c) 2013 Mobile Tuts. All rights reserved.
//

#define kMTColorGray [UIColor colorWithRed:0.737 green:0.737 blue:0.737 alpha:1.0]
#define kMTColorGreen [UIColor colorWithRed:0.325 green:0.573 blue:0.388 alpha:1.0]
#define kMTColorOrange [UIColor colorWithRed:1.000 green:0.306 blue:0.373 alpha:1.0]

#pragma mark -
#pragma mark User Defaults
extern NSString * const MTRainUserDefaultsLocation;
extern NSString * const MTRainUserDefaultsLocations;
extern NSString * const MTRainUserDefaultsTemperatureUnit;

#pragma mark -
#pragma mark Notifications
extern NSString * const MTRainDidAddLocationNotification;
extern NSString * const MTRainLocationDidChangeNotification;
extern NSString * const MTRainReachabilityStatusDidChangeNotification;
extern NSString * const MTRainWeatherDataDidChangeChangeNotification;
extern NSString * const MTRainTemperatureUnitDidChangeNotification;

#pragma mark -
#pragma mark Location Keys
extern NSString * const MTLocationKeyCity;
extern NSString * const MTLocationKeyCountry;
extern NSString * const MTLocationKeyLatitude;
extern NSString * const MTLocationKeyLongitude;

#pragma mark -
#pragma mark Forecast API
extern NSString * const MTForecastAPIKey;
