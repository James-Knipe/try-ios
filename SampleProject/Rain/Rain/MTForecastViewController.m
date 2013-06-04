//
//  MTForecastViewController.m
//  Rain
//
//  Created by Bart Jacobs on 10/05/13.
//  Copyright (c) 2013 Mobile Tuts. All rights reserved.
//

#import "MTForecastViewController.h"

#import "MTDayCell.h"

@interface MTForecastViewController ()

@property (strong, nonatomic) NSDictionary *response;
@property (strong, nonatomic) NSArray *forecast;

@end

@implementation MTForecastViewController

static NSString *DayCell = @"DayCell";

#pragma mark -
#pragma mark Initialization
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        // Add Observer
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self selector:@selector(weatherDataDidChangeChange:) name:MTRainWeatherDataDidChangeChangeNotification object:nil];
        [nc addObserver:self selector:@selector(temperatureUnitDidChange:) name:MTRainTemperatureUnitDidChangeNotification object:nil];
    }
    
    return self;
}

#pragma mark -
#pragma mark View Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Configure Table View
    [self.tableView registerClass:[MTDayCell class] forCellReuseIdentifier:DayCell];
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
    return self.forecast ? 1 : 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.forecast count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MTDayCell *cell = [tableView dequeueReusableCellWithIdentifier:DayCell forIndexPath:indexPath];
    
    // Fetch Data
    NSDictionary *data = [self.forecast objectAtIndex:indexPath.row];
    
    // Initialize Date Formatter
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[data[@"time"] doubleValue]];
    
    // Configure Cell
    [dateFormatter setDateFormat:@"EEE"];
    [cell.labelDay setText:[dateFormatter stringFromDate:date]];
    
    [dateFormatter setDateFormat:@"d"];
    [cell.labelDate setText:[dateFormatter stringFromDate:date]];
    
    float tempMin = [data[@"temperatureMin"] floatValue];
    float tempMax = [data[@"temperatureMax"] floatValue];
    [cell.labelTemp setText:[NSString stringWithFormat:@"%.0f°/%.0f°", tempMin, tempMax]];
    
    [cell.labelWind setText:[NSString stringWithFormat:@"%.0f", [data[@"windSpeed"] floatValue]]];
    
    float rainProbability = 0.0;
    if (data[@"precipProbability"]) {
        rainProbability = [data[@"precipProbability"] floatValue] * 100.0;
    }
    
    [cell.labelRain setText:[NSString stringWithFormat:@"%.0f", rainProbability]];
    
    return cell;
}

#pragma mark -
#pragma mark Table View Delegate Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.0;
}

#pragma mark -
#pragma mark View Methods
- (void)updateView {
    // Reload Table View
    [self.tableView reloadData];
}

#pragma mark -
#pragma mark Notification Handling
- (void)weatherDataDidChangeChange:(NSNotification *)notification {
    // Update Response & Forcast
    [self setResponse:[notification userInfo]];
    [self setForecast:self.response[@"daily"][@"data"]];
    
    // Update View
    [self updateView];
}

- (void)temperatureUnitDidChange:(NSNotification *)notification {
    // Update View
    [self updateView];
}

@end
