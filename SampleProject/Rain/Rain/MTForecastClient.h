//
//  MTForecastClient.h
//  Rain
//
//  Created by Bart Jacobs on 18/05/13.
//  Copyright (c) 2013 Mobile Tuts. All rights reserved.
//

#import "AFHTTPClient.h"

typedef void (^MTForecastClientCompletionBlock)(BOOL success, NSDictionary *response);

@interface MTForecastClient : AFHTTPClient

#pragma mark -
#pragma mark Shared Client
+ (MTForecastClient *)sharedClient;

#pragma mark -
#pragma mark Instance Methods
- (void)requestWeatherForCoordinate:(CLLocationCoordinate2D)coordinate completion:(MTForecastClientCompletionBlock)completion;

@end
