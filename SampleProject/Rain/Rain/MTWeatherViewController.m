//
//  MTWeatherViewController.m
//  Rain
//
//  Created by Kevin on 5/21/13.
//  Copyright (c) 2013 Kevin. All rights reserved.
//

#import "MTWeatherViewController.h"

@interface MTWeatherViewController () <CLLocationManagerDelegate>
{
    BOOL _locationFound;
}
@property (strong, nonatomic) NSDictionary *location;
@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation MTWeatherViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialize Location Manager
        self.locationManager = [[CLLocationManager alloc] init];
        // Configure Location Manager
        [self.locationManager setDelegate:self];
        [self.locationManager setDesiredAccuracy:kCLLocationAccuracyKilometer];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Load Location
    self.location = [[NSUserDefaults standardUserDefaults] objectForKey:MTRainUserDefaultsLocation];
    if(!self.location){
        [self.locationManager startUpdatingLocation];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setLocation:(NSDictionary *)location
{
    if(_location != location){
        _location = location;
        // Update User Defaults
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        [ud setObject:location forKey:MTRainUserDefaultsLocation];
        [ud synchronize];
        // Post Notification
        NSNotification *notification1 = [NSNotification notificationWithName:MTRainLocationDidChangeNotification object:self userInfo:location];
        // Update View
        [self updateView];
    }
}

- (void)updateView
{
    // Update Location Label
    [self.labelLocation setText:[self.location objectForKey:MTLocationKeyCity]];
}

#pragma mark - MTLocationViewControllerDelegate
- (void)controllerShouldAddCurrentLocation:(MTLocationViewController *)controller {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [self.locationManager startUpdatingLocation];
}

- (void)controller:(MTLocationViewController *)controller didSelectLocation:(NSDictionary *)location {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    self.location = location;
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    if(![locations count] || _locationFound){
        return;
    }
    // Stop Updating Location
    _locationFound = YES;
    [manager stopUpdatingLocation];
    // Current Location
    CLLocation *currentLocation = [locations objectAtIndex:0];
    // Reverse Geocoder
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        if([placemarks count]){
            _locationFound = NO;
            [self processPlacemark:[placemarks objectAtIndex:0]];
        }
    }];
}

- (void)processPlacemark:(CLPlacemark *)placemark {
    // Extract Data
    NSString *city = [placemark locality];
    NSString *country = [placemark country];
    CLLocationDegrees lat = placemark.location.coordinate.latitude;
    CLLocationDegrees lon = placemark.location.coordinate.longitude;
    // Create Location Dictionary
    NSDictionary *currentLocation = @{ MTLocationKeyCity : city,
                                       MTLocationKeyCountry : country,
                                       MTLocationKeyLatitude : @(lat),
                                       MTLocationKeyLongitude : @(lon) };
    // Add to Locations
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSMutableArray *locations = [NSMutableArray arrayWithArray:[ud objectForKey:MTRainUserDefaultsLocations]];
    [locations addObject:currentLocation];
    [locations sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:MTLocationKeyCity ascending:YES]]];
    [ud setObject:locations forKey:MTRainUserDefaultsLocations];
    // Synchronize
    [ud synchronize];
    // Update Current Location
    self.location = currentLocation;
    // Post Notifications
    NSNotification *notification2 = [NSNotification notificationWithName:MTRainDidAddLocationNotification object:self userInfo:currentLocation];
    [[NSNotificationCenter defaultCenter] postNotification:notification2];
}

@end
