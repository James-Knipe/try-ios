//
//  ViewController.m
//  CustomPopover
//
//  Created by Kevin on 5/11/13.
//  Copyright (c) 2013 Kevin. All rights reserved.
//

#import "ViewController.h"
#import "PopoverBackgroundView.h"

@interface ViewController ()

- (void)showPopover:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *popoverButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(showPopover:)];
    self.navigationItem.rightBarButtonItem = popoverButton;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showPopover:(id)sender
{
    if (self.popController.popoverVisible) {
        [self.popController dismissPopoverAnimated:YES];
        return;
    }
    UIViewController *contentViewController = [[UIViewController alloc] init];
    contentViewController.view.backgroundColor = [UIColor yellowColor];
    UIPopoverController *popController = [[UIPopoverController alloc] initWithContentViewController:contentViewController];
    popController.popoverBackgroundViewClass = [PopoverBackgroundView class];
    popController.popoverContentSize = CGSizeMake(300.0f, 600.0f);
    self.popController = popController;
    [self.popController presentPopoverFromBarButtonItem:sender
                               permittedArrowDirections:UIPopoverArrowDirectionUp
                                               animated:YES];
}

@end
