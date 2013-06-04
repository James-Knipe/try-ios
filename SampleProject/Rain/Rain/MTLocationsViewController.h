//
//  MTLocationsViewController.h
//  Rain
//
//  Created by Bart Jacobs on 10/05/13.
//  Copyright (c) 2013 Mobile Tuts. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MTLocationsViewControllerDelegate;

@interface MTLocationsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) id<MTLocationsViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editButton;

@end

@protocol MTLocationsViewControllerDelegate <NSObject>
- (void)controllerShouldAddCurrentLocation:(MTLocationsViewController *)controller;
- (void)controller:(MTLocationsViewController *)controller didSelectLocation:(NSDictionary *)location;
@end
