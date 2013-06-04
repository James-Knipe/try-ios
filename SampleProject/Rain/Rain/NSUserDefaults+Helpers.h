//
//  NSUserDefaults+Helpers.h
//  Rain
//
//  Created by Bart Jacobs on 30/05/13.
//  Copyright (c) 2013 Mobile Tuts. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSUserDefaults (Helpers)

#pragma mark -
#pragma mark Temperature
+ (BOOL)isDefaultCelcius;
+ (void)setDefaultToCelcius;
+ (void)setDefaultToFahrenheit;

@end
