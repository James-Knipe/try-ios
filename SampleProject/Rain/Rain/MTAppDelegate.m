//
//  MTAppDelegate.m
//  Rain
//
//  Created by Bart Jacobs on 10/05/13.
//  Copyright (c) 2013 Mobile Tuts. All rights reserved.
//

#import "MTAppDelegate.h"

#import "MTWeatherViewController.h"
#import "MTForecastViewController.h"
#import "MTLocationViewController.h"

@interface MTAppDelegate ()

@property (strong, nonatomic) IIViewDeckController *viewDeckController;

@end

@implementation MTAppDelegate

#pragma mark -
#pragma mark Application Did Finish Launching with Options
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Initialize View Controllers
    MTLocationViewController *leftViewController = [[MTLocationViewController alloc] initWithNibName:@"MTLocationViewController" bundle:nil];
    MTForecastViewController *rightViewController = [[MTForecastViewController alloc] initWithNibName:@"MTForecastViewController" bundle:nil];
    MTWeatherViewController *centerViewController = [[MTWeatherViewController alloc] initWithNibName:@"MTWeatherViewController" bundle:nil];
    
    // Configure Locations View Controller
    [leftViewController setDelegate:centerViewController];
    
    // Initialize View Deck Controller
    self.viewDeckController = [[IIViewDeckController alloc] initWithCenterViewController:centerViewController leftViewController:leftViewController rightViewController:rightViewController];
    
    // Initialize Window
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // Configure Window
    [self.window setRootViewController:self.viewDeckController];
    [self.window makeKeyAndVisible];
    
    return YES;
}

#pragma mark -
#pragma mark Application State Changes
- (void)applicationWillResignActive:(UIApplication *)application {
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    
}

@end
