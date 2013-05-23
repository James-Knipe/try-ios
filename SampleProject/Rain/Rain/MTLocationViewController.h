//
//  MTLocationViewController.h
//  Rain
//
//  Created by Kevin on 5/21/13.
//  Copyright (c) 2013 Kevin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MTLocationViewControllerDelegate;

@interface MTLocationViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) id<MTLocationViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editButton;
@end

@protocol MTLocationViewControllerDelegate <NSObject>
- (void)controllerShouldAddCurrentLocation:(MTLocationViewController *)controller;
- (void)controller:(MTLocationViewController *)controller didSelectLocation:(NSDictionary *)location;
@end
