//
//  MTForecastClient.m
//  Rain
//
//  Created by Kevin on 5/22/13.
//  Copyright (c) 2013 Kevin. All rights reserved.
//

#import "MTForecastClient.h"

@implementation MTForecastClient

+ (MTForecastClient *)sharedClient
{
    static dispatch_once_t predicate;
    static MTForecastClient *_sharedClient = nil;
    dispatch_once(&predicate, ^{
        _sharedClient = [self alloc];
        _sharedClient = [_sharedClient initWithBaseURL:[self baseURL]];
    });
    return _sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    if(self){
        // Accept HTTP Header
        [self setDefaultHeader:@"Accept" value:@"Application/json"];
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

+ (NSURL *)baseURL
{
    return [NSURL URLWithString:[NSString stringWithFormat:@"https://api.forecast.io/forecast/%@/", MTForecastAPIKey]];
}

- (void)requestWeatherForCoordinate:(CLLocationCoordinate2D)coordinate completion:(MTForecastClientCompletionBlock)completion
{
    NSString *path = [NSString stringWithFormat:@"%f,%f", coordinate.latitude, coordinate.longitude];
    [self getPath:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(completion){
            completion(YES, responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completion) {
            completion(NO, nil);
            NSLog(@"Unable to fetch weather data due to error %@ with user info %@.", error, error.userInfo);
        }
    }];
}

@end
