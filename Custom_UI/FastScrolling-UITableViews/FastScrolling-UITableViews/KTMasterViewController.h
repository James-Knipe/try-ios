//
//  KTMasterViewController.h
//  FastScrolling-UITableViews
//
//  Created by Kurry L Tran on 6/25/13.
//  Copyright (c) 2013 Kurry L Tran. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KTDetailViewController;

@interface KTMasterViewController : UITableViewController

@property (strong, nonatomic) KTDetailViewController *detailViewController;

@end
