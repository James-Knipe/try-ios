//
//  KTDetailViewController.h
//  FastScrolling-UITableViews
//
//  Created by Kurry L Tran on 6/25/13.
//  Copyright (c) 2013 Kurry L Tran. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KTDetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
