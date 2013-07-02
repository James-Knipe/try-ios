//
//  FBCDMasterViewController.h
//  FailedBankCD
//
//  Created by Kevin on 7/2/13.
//  Copyright (c) 2013 aurora. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FBCDMasterViewController : UITableViewController

@property(nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property(nonatomic, strong) NSArray *failedBankInfos;

@end
