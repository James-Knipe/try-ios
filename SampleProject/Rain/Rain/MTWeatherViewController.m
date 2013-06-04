//
//  MTWeatherViewController.m
//  Rain
//
//  Created by Bart Jacobs on 10/05/13.
//  Copyright (c) 2013 Mobile Tuts. All rights reserved.
//

#import "MTWeatherViewController.h"

#import "MTHourCell.h"
#import "MTForecastClient.h"

@interface MTWeatherViewController () <CLLocationManagerDelegate> {
    BOOL _locationFound;
}

@property (strong, nonatomic) NSDictionary *location;
@property (strong, nonatomic) NSDictionary *response;
@property (strong, nonatomic) NSArray *forecast;

@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation MTWeatherViewController

static NSString *HourCell = @"HourCell";

#pragma mark -
#pragma mark Initialization
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
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
        [nc addObserver:self selector:@selector(weatherDataDidChangeChange:) name:MTRainWeatherDataDidChangeChangeNotification object:nil];
        [nc addObserver:self selector:@selector(temperatureUnitDidChange:) name:MTRainTemperatureUnitDidChangeNotification object:nil];
    }
    
    return self;
}

#pragma mark -
#pragma mark Memory Management
- (void)dealloc {
    // Remove Observer
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark -
#pragma mark Setters & Getters
- (void)setLocation:(NSDictionary *)location {
    if (_location != location) {
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
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Load Location
    self.location = [[NSUserDefaults standardUserDefaults] objectForKey:MTRainUserDefaultsLocation];
    
    if (!self.location) {
        [self.locationManager startUpdatingLocation];
    }
    
    // Configure Collection View
    [self.collectionView setBackgroundColor:[UIColor clearColor]];
    [self.collectionView registerClass:[MTHourCell class] forCellWithReuseIdentifier:HourCell];
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
#pragma mark Collection View Data Source Methods
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.forecast ? 1 : 0;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.forecast count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MTHourCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:HourCell forIndexPath:indexPath];
    
    // Fetch Data
    NSDictionary *data = [self.forecast objectAtIndex:indexPath.row];
    
    // Initialize Date Formatter
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    [timeFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    [timeFormatter setDateFormat:@"ha"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[data[@"time"] doubleValue]];
    
    // Configure Cell
    [cell.labelTime setText:[timeFormatter stringFromDate:date]];
    [cell.labelTemp setText:[MTSettings formatTemperature:data[@"temperature"]]];
    [cell.labelWind setText:[NSString stringWithFormat:@"%.0fMP", [data[@"windSpeed"] floatValue]]];
    
    float rainProbability = 0.0;
    if (data[@"precipProbability"]) {
        rainProbability = [data[@"precipProbability"] floatValue] * 100.0;
    }
    
    [cell.labelRain setText:[NSString stringWithFormat:@"%.0f%%", rainProbability]];
    
    return cell;
}

#pragma mark -
#pragma mark Collection View Delegate & Collection View Delegate Flow Layout Methods
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(80.0, 120.0);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0.0, 10.0, 0.0, 10.0);
}

#pragma mark -
#pragma mark Location Manager Delegate Methods
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    if (![locations count] || _locationFound) return;
    
    // Stop Updating Location
    _locationFound = YES;
    [manager stopUpdatingLocation];
    
    // Current Location
    CLLocation *currentLocation = [locations objectAtIndex:0];
    
    // Reverse Geocode
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        if ([placemarks count]) {
            _locationFound = NO;
            [self processPlacemark:[placemarks objectAtIndex:0]];
        }
    }];
}

#pragma mark -
#pragma mark Locations View Controller Delegate Methods
- (void)controllerShouldAddCurrentLocation:(MTLocationsViewController *)controller {
    // Start Updating Location
    [self.locationManager startUpdatingLocation];
}

- (void)controller:(MTLocationsViewController *)controller didSelectLocation:(NSDictionary *)location {
    // Update Location
    self.location = location;
}

#pragma mark -
#pragma mark View Methods
- (void)updateView {
    // Update Location Label
    [self.labelLocation setText:[self.location objectForKey:MTLocationKeyCity]];
    
    // Update Current Weather
    [self updateCurrentWeather];
    
    // Reload Collection View
    [self.collectionView reloadData];
}

- (void)updateCurrentWeather {
    // Weather Data
    NSDictionary *data = [self.response objectForKey:@"currently"];
    
    // Update Date Label
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    [dateFormatter setDateFormat:@"EEEE, MMM d"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[data[@"time"] doubleValue]];
    [self.labelDate setText:[dateFormatter stringFromDate:date]];
    
    // Update Temperature Label
    [self.labelTemp setText:[MTSettings formatTemperature:data[@"temperature"]]];
    
    // Update Time Label
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    [timeFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    [timeFormatter setDateFormat:@"ha"];
    [self.labelTime setText:[timeFormatter stringFromDate:[NSDate date]]];
    
    // Update Wind Label
    [self.labelWind setText:[NSString stringWithFormat:@"%.0fMP", [data[@"windSpeed"] floatValue]]];
    
    // Update Rain Label
    float rainProbability = 0.0;
    if (data[@"precipProbability"]) {
        rainProbability = [data[@"precipProbability"] floatValue] * 100.0;
    }
    
    [self.labelRain setText:[NSString stringWithFormat:@"%.0f%%", rainProbability]];
}

#pragma mark -
#pragma mark Actions
- (IBAction)openLeftView:(id)sender {
    [self.viewDeckController toggleLeftViewAnimated:YES];
}

- (IBAction)refresh:(id)sender {
    if (self.location) {
        [self fetchWeatherData];
    }
}

#pragma mark -
#pragma mark Notification Handling
- (void)applicationDidBecomeActive:(NSNotification *)notification {
    if (self.location) {
        [self fetchWeatherData];
    }
}

- (void)reachabilityStatusDidChange:(NSNotification *)notification {
    MTForecastClient *forecastClient = [notification object];
    NSLog(@"Reachability Status > %i", forecastClient.networkReachabilityStatus);
    
    // Update Refresh Button
    self.buttonRefresh.enabled = (forecastClient.networkReachabilityStatus != AFNetworkReachabilityStatusNotReachable);
}

- (void)weatherDataDidChangeChange:(NSNotification *)notification {
    // Update Response & Forcast
    [self setResponse:[notification userInfo]];
    [self setForecast:self.response[@"hourly"][@"data"]];
    
    // Update View
    [self updateView];
}

- (void)temperatureUnitDidChange:(NSNotification *)notification {
    // Update View
    [self updateView];
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

- (void)fetchWeatherData {
    if ([[MTForecastClient sharedClient] networkReachabilityStatus] == AFNetworkReachabilityStatusNotReachable) return;
    
    // Show Progress HUD
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    
    // Query Forecast API
    double lat = [[_location objectForKey:MTLocationKeyLatitude] doubleValue];
    double lng = [[_location objectForKey:MTLocationKeyLongitude] doubleValue];
    [[MTForecastClient sharedClient] requestWeatherForCoordinate:CLLocationCoordinate2DMake(lat, lng) completion:^(BOOL success, NSDictionary *response) {
        // Dismiss Progress HUD
        [SVProgressHUD dismiss];
        
        if (response && [response isKindOfClass:[NSDictionary class]]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                // Post Notification on Main Thread
                NSNotification *notification = [NSNotification notificationWithName:MTRainWeatherDataDidChangeChangeNotification object:nil userInfo:response];
                [[NSNotificationCenter defaultCenter] postNotification:notification];
            });
        }
    }];
}

@end
