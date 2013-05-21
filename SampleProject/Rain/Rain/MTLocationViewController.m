//
//  MTLocationViewController.m
//  Rain
//
//  Created by Kevin on 5/21/13.
//  Copyright (c) 2013 Kevin. All rights reserved.
//

#import "MTLocationViewController.h"

static NSString *LocationCell = @"LocationCell";

@interface MTLocationViewController ()
@property (strong, nonatomic) NSMutableArray *locations;
@end

@implementation MTLocationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Load Locations
        [self loadLocations];
        // Add Observer
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didAddLocation) name:MTRainDidAddLocationNotification object:nil];
    }
    return self;
}

- (void)loadLocations
{
    self.locations = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:MTRainUserDefaultsLocations]];
}

- (void)didAddLocation:(NSNotification *)notification
{
    NSDictionary *location = [notification userInfo];
    [self.locations addObject:location];
    [self.locations sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:MTLocationKeyCity ascending:YES]]];
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Setup View
    [self setupView];
}

- (void)setupView
{
    // Register Class for Cell Reuse
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:LocationCell];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    // Remove Observer
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if(_delegate){
        _delegate = nil;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ([self.locations count] + 1);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LocationCell forIndexPath:indexPath];
    // Configure Cell
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0){
        [cell.textLabel setText:@"Add Current Location"];
    } else {
        // Fetch Location
        NSDictionary *location = [self.locations objectAtIndex:(indexPath.row -1)];
        // Configure Cell
        [cell.textLabel setText:[NSString stringWithFormat:@"%@, %@", location[MTLocationKeyCity], location[MTLocationKeyCountry]]];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.row == 0){
        [self.delegate controllerShouldAddCurrentLocation:self];
    } else {
        // Fetch Location
        NSDictionary *location = [self.locations objectAtIndex:(indexPath.row - 1)];
        // Notify Delegate
        [self.delegate controller:self didSelectLocation:location];
    }
    // Show Center View Controller
    [self.viewDeckController closeLeftViewAnimated:YES];
}

@end
