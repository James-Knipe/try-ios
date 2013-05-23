//
//  MTForecastClient.h
//  Rain
//
//  Created by Kevin on 5/22/13.
//  Copyright (c) 2013 Kevin. All rights reserved.
//

#import "AFHTTPClient.h"

typedef void(^MTForecastClientCompletionBlock)(BOOL success, NSDictionary *response);

@interface MTForecastClient : AFHTTPClient

#pragma mark Shared Client
#pragma mark -
#pragma mark Shared Client
+ (MTForecastClient *)sharedClient;
#pragma mark -
#pragma mark Instance Method
- (void)requestWeatherForCoordinate:(CLLocationCoordinate2D)coordinate completion:(MTForecastClientCompletionBlock)completion;
@end
