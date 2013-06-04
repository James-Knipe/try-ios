//
//  MTForecastViewController.h
//  Rain
//
//  Created by Bart Jacobs on 10/05/13.
//  Copyright (c) 2013 Mobile Tuts. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTForecastViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
