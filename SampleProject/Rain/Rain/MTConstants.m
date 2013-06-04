//
//  MTConstants.m
//  Rain
//
//  Created by Bart Jacobs on 10/05/13.
//  Copyright (c) 2013 Mobile Tuts. All rights reserved.
//

#import "MTConstants.h"

#pragma mark -
#pragma mark User Defaults
NSString * const MTRainUserDefaultsLocation = @"location";
NSString * const MTRainUserDefaultsLocations = @"locations";
NSString * const MTRainUserDefaultsTemperatureUnit = @"temperatureUnit";

#pragma mark -
#pragma mark Notifications
NSString * const MTRainDidAddLocationNotification = @"com.mobileTuts.MTRainDidAddLocationNotification";
NSString * const MTRainLocationDidChangeNotification = @"com.mobileTuts.MTRainLocationDidChangeNotification";
NSString * const MTRainReachabilityStatusDidChangeNotification = @"com.mobileTuts.MTRainReachabilityStatusDidChangeNotification";
NSString * const MTRainWeatherDataDidChangeChangeNotification = @"com.mobileTuts.MTRainWeatherDataDidChangeChangeNotification";
NSString * const MTRainTemperatureUnitDidChangeNotification = @"com.mobileTuts.MTRainTemperatureUnitDidChangeNotification";

#pragma mark -
#pragma mark Location Keys
NSString * const MTLocationKeyCity = @"city";
NSString * const MTLocationKeyCountry = @"country";
NSString * const MTLocationKeyLatitude = @"latitude";
NSString * const MTLocationKeyLongitude = @"longitude";

#pragma mark -
#pragma mark Forecast API
NSString * const MTForecastAPIKey = @"94f57ac46c136dccadf2045f956f770b";
