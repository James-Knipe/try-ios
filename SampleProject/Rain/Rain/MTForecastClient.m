//
//  MTForecastClient.m
//  Rain
//
//  Created by Bart Jacobs on 18/05/13.
//  Copyright (c) 2013 Mobile Tuts. All rights reserved.
//

#import "MTForecastClient.h"

@implementation MTForecastClient

#pragma mark -
#pragma mark Shared Client
+ (MTForecastClient *)sharedClient {
    static dispatch_once_t predicate;
    static MTForecastClient *_sharedClient = nil;
    
    dispatch_once(&predicate, ^{
        _sharedClient = [self alloc];
        _sharedClient = [_sharedClient initWithBaseURL:[self baseURL]];
    });
    
    return _sharedClient;
}

#pragma mark -
#pragma mark Initialization
- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    
    if (self) {
        // Accept HTTP Header
        [self setDefaultHeader:@"Accept" value:@"application/json"];
        
        // Register HTTP Operation Class
        [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
        
        // Reachability
        __weak typeof(self)weakSelf = self;
        [self setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            [[NSNotificationCenter defaultCenter] postNotificationName:MTRainReachabilityStatusDidChangeNotification object:weakSelf];
        }];
    }
    
    return self;
}

#pragma mark -
#pragma mark Instance Methods
- (void)requestWeatherForCoordinate:(CLLocationCoordinate2D)coordinate completion:(MTForecastClientCompletionBlock)completion {
    NSString *path = [NSString stringWithFormat:@"%f,%f", coordinate.latitude, coordinate.longitude];
    [self getPath:path parameters:nil success:^(AFHTTPRequestOperation *operation, id response) {
        if (completion) {
            completion(YES, response);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completion) {
            completion(NO, nil);
            
            NSLog(@"Unable to fetch weather data due to error %@ with user info %@.", error, error.userInfo);
        }
    }];
}

#pragma mark -
#pragma mark Private Class Methods
+ (NSURL *)baseURL {
    return [NSURL URLWithString:[NSString stringWithFormat:@"https://api.forecast.io/forecast/%@/", MTForecastAPIKey]];
}

@end
