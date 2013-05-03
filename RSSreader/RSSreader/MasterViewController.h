//
//  MasterViewController.h
//  RSSreader
//
//  Created by Kevin on 4/29/13.
//  Copyright (c) 2013 Kevin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MasterViewController : UITableViewController<NSXMLParserDelegate>

@property(strong, nonatomic) IBOutlet UITableView *tableView;

@end
