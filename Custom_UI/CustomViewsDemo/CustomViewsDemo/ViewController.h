//
//  ViewController.h
//  CustomViewsDemo
//
//  Created by Kevin on 4/29/13.
//  Copyright (c) 2013 Kevin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTextInputViewController.h"

@interface ViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, CustomTextInputViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *table;

- (IBAction)addItem:(id)sender;

@end
