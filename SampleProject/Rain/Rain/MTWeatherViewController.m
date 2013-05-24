//
//  MTWeatherViewController.m
//  Rain
//
//  Created by Kevin on 5/21/13.
//  Copyright (c) 2013 Kevin. All rights reserved.
//

#import "MTWeatherViewController.h"
#import "MTForecastClient.h"

@interface MTWeatherViewController () <CLLocationManagerDelegate>
{
    BOOL _locationFound;
}
@property (strong, nonatomic) NSDictionary *location;
@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation MTWeatherViewController

#pragma mark -
#pragma mark Initialization
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialize Location Manager
        self.locationManager = [[CLLocationManager alloc] init];
        // Configure Location Manager
        [self.locationManager setDelegate:self];
        [self.locationManager setDesiredAccuracy:kCLLocationAccuracyKilometer];
        // Add Observer
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self selector:@selector(applicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
        [nc addObserver:self selector:@selector(reachabilityStatusDidChange:) name:MTRainReachabilityStatusDidChangeNotification object:nil];
    }
    return self;
}

#pragma mark -
#pragma mark Memory Management
- (void)dealloc
{
    // Remove Observer
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Setters & Getters
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
        [[NSNotificationCenter defaultCenter] postNotification:notification1];
        // Update View
        [self updateView];
        // Request Location
        [self fetchWeatherData];
    }
}

#pragma mark -
#pragma mark View Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Load Location
    self.location = [[NSUserDefaults standardUserDefaults] objectForKey:MTRainUserDefaultsLocation];
    if(!self.location){
        [self.locationManager startUpdatingLocation];
    }
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}

#pragma mark -
#pragma mark Location Manager Delegate Methods
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

#pragma mark -
#pragma mark Location View Controller Delegate Methods
- (void)controllerShouldAddCurrentLocation:(MTLocationViewController *)controller {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [self.locationManager startUpdatingLocation];
}

- (void)controller:(MTLocationViewController *)controller didSelectLocation:(NSDictionary *)location {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    self.location = location;
}

#pragma mark -
#pragma mark View Methods
- (void)updateView
{
    // Update Location Label
    [self.labelLocation setText:[self.location objectForKey:MTLocationKeyCity]];
}

#pragma mark -
#pragma mark Actions
- (IBAction)refresh:(id)sender
{
    if(self.location){
        [self fetchWeatherData];
    }
}

#pragma mark -
#pragma mark Notification Handling
- (void)applicationDidBecomeActive:(NSNotification *)notification
{
    if(self.location){
        [self fetchWeatherData];
    }
}

- (void)reachabilityStatusDidChange:(NSNotification *)notification
{
    MTForecastClient *forecastClient = [notification object];
    NSLog(@"Reachability Status > %i", forecastClient.networkReachabilityStatus);
    self.buttonRefresh.enabled = (forecastClient.networkReachabilityStatus != AFNetworkReachabilityStatusNotReachable);
}

#pragma mark -
#pragma mark Helper Methods
- (void)processPlacemark:(CLPlacemark *)placemark {
    // Extract Data
    // NSString *city = [placemark.addressDictionary valueForKey:@"City"];
    // NSString *street = [placemark.addressDictionary valueForKey:@"Street"];
    // NSString *city = [placemark.addressDictionary locality];
    // NSString *country = [placemark country];
    NSString *country = placemark.country;
    NSString *city = placemark.administrativeArea;
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

- (void)fetchWeatherData
{
    if([[MTForecastClient sharedClient] networkReachabilityStatus] == AFNetworkReachabilityStatusNotReachable)
        return;
    
    // Show Progress HUD
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    // Query Forecast API
    double lat = [[_location objectForKey:MTLocationKeyLatitude] doubleValue];
    double lng = [[_location objectForKey:MTLocationKeyLongitude] doubleValue];
    [[MTForecastClient sharedClient] requestWeatherForCoordinate:CLLocationCoordinate2DMake(lat, lng) completion:^(BOOL success, NSDictionary *response) {
        // Dismiss Progress HUD
        [SVProgressHUD dismiss];
        NSLog(@"response > %@", response);
    }];
}

@end
