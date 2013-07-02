//
//  ViewController.m
//  ARC Simple
//
//  Created by Kevin on 6/25/13.
//  Copyright (c) 2013 Kevin. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    __weak NSString *test = @"bbb";
    __weak NSString *test2 = [[NSString alloc] initWithFormat:@"ccc"];
    
    NSLog(@"%@", test);
    NSLog(@"%@", test2);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
