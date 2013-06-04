//
//  NSUserDefaults+Helpers.m
//  Rain
//
//  Created by Bart Jacobs on 30/05/13.
//  Copyright (c) 2013 Mobile Tuts. All rights reserved.
//

#import "NSUserDefaults+Helpers.h"

@implementation NSUserDefaults (Helpers)

#pragma mark -
#pragma mark Temperature
+ (BOOL)isDefaultCelcius {
    return [[NSUserDefaults standardUserDefaults] integerForKey:MTRainUserDefaultsTemperatureUnit] == 1;
}

+ (void)setDefaultToCelcius {
    // Update User Defaults
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setInteger:1 forKey:MTRainUserDefaultsTemperatureUnit];
    [ud synchronize];
    
    // Post Notification
    [[NSNotificationCenter defaultCenter] postNotificationName:MTRainTemperatureUnitDidChangeNotification object:nil];
}

+ (void)setDefaultToFahrenheit {
    // Update User Defaults
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setInteger:0 forKey:MTRainUserDefaultsTemperatureUnit];
    [ud synchronize];
    
    // Post Notification
    [[NSNotificationCenter defaultCenter] postNotificationName:MTRainTemperatureUnitDidChangeNotification object:nil];
}

@end
