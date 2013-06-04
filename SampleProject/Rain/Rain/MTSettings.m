//
//  MTSettings.m
//  Rain
//
//  Created by Bart Jacobs on 30/05/13.
//  Copyright (c) 2013 Mobile Tuts. All rights reserved.
//

#import "MTSettings.h"

#import "NSUserDefaults+Helpers.h"

@implementation MTSettings

#pragma mark -
#pragma mark Convenience Methods
+ (NSString *)formatTemperature:(NSNumber *)temperature {
    float value = [temperature floatValue];
    
    if ([NSUserDefaults isDefaultCelcius]) {
        value = (value  -  32.0)  *  (5.0 / 9.0);
    }
    
    return [NSString stringWithFormat:@"%.0f°", value];
}

@end
