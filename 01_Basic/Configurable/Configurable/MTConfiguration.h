//
//  MTConfiguration.h
//  Configurable
//
//  Created by Kevin on 7/13/13.
//  Copyright (c) 2013 aurora. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTConfiguration : NSObject
#pragma mark -
+ (NSString *)configuration;
#pragma mark -
+ (NSString *)APIEndpoint;
+ (BOOL)isLoggingEnabled;
@end
