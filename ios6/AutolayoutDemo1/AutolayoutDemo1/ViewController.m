//
//  ViewController.m
//  AutolayoutDemo1
//
//  Created by Kevin on 4/27/13.
//  Copyright (c) 2013 Kevin. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property(nonatomic, strong) UIButton *button;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /* 1) Create button */
    self.button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.button.translatesAutoresizingMaskIntoConstraints = NO;
    [self.button setTitle:@"Button" forState:UIControlStateNormal];
    [self.view addSubview:self.button];
    
    UIView *superView = self.button.superview;
    
    /* 2) Create the constraint to put the button horizontally in the center*/
    NSLayoutConstraint *centerXConstraint = [NSLayoutConstraint constraintWithItem:self.button attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f];
    
    /* 3) Create the constraint to put the button vertically in the center */
    NSLayoutConstraint *centerYConstraint = [NSLayoutConstraint constraintWithItem:self.button attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f];
    
    /* Add all constraints to the superview of the button */
    [superView addConstraints:@[centerXConstraint, centerYConstraint]];
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
