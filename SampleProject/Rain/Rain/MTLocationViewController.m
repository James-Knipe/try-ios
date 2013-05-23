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

#pragma mark -
#pragma mark Initialization
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

#pragma mark -
#pragma mark Memory Management
- (void)dealloc
{
    // Remove Observer
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if(_delegate){
        _delegate = nil;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark View Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Setup View
    [self setupView];
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
#pragma mark Table View Data Source Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return ([self.locations count] + 1);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LocationCell forIndexPath:indexPath];
    
    // Configure Cell
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        [cell.textLabel setText:@"Add Current Location"];
        
    } else {
        // Fetch Location
        NSDictionary *location = [self.locations objectAtIndex:(indexPath.row - 1)];
        
        // Configure Cell
        [cell.textLabel setText:[NSString stringWithFormat:@"%@, %@", location[MTLocationKeyCity], location[MTLocationKeyCountry]]];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return NO;
    }
    
    // Fetch Location
    NSDictionary *location = [self.locations objectAtIndex:(indexPath.row - 1)];
    
    return ![self isCurrentLocation:location];
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Update Locations
        [self.locations removeObjectAtIndex:(indexPath.row - 1)];
        
        // Update User Defaults
        [[NSUserDefaults standardUserDefaults] setObject:self.locations forKey:MTRainUserDefaultsLocations];
        
        // Update Table View
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
    }
}

#pragma mark -
#pragma mark Table View Delegate Methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        // Notify Delegate
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

#pragma mark -
#pragma mark View Methods
- (void)setupView {
    // Register Class for Cell Reuse
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:LocationCell];
}

- (void)updateView {
    
}

#pragma mark -
#pragma mark Actions
- (IBAction)editLocations:(id)sender {
    [self.tableView setEditing:![self.tableView isEditing] animated:YES];
}

#pragma mark -
#pragma mark Helper Methods
- (void)loadLocations {
    self.locations = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:MTRainUserDefaultsLocations]];
}

- (BOOL)isCurrentLocation:(NSDictionary *)location {
    // Fetch Current Location
    NSDictionary *currentLocation = [[NSUserDefaults standardUserDefaults] objectForKey:MTRainUserDefaultsLocation];
    
    if ([location[MTLocationKeyLatitude] doubleValue] == [currentLocation[MTLocationKeyLatitude] doubleValue] &&
        [location[MTLocationKeyLongitude] doubleValue] == [currentLocation[MTLocationKeyLongitude] doubleValue]) {
        return YES;
    }
    
    return NO;
}

#pragma mark -
#pragma mark Notification Handling
- (void)didAddLocation:(NSNotification *)notification {
    NSDictionary *location = [notification userInfo];
    [self.locations addObject:location];
    [self.locations sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:MTLocationKeyCity ascending:YES]]];
    [self.tableView reloadData];
}

@end
