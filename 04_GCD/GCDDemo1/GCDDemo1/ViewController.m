//
//  ViewController.m
//  GCDDemo1
//
//  Created by Kevin on 8/2/13.
//  Copyright (c) 2013 aurora. All rights reserved.
//

// http://stackoverflow.com/questions/14569693/timer-inside-global-queue-is-not-calling-in-ios

#import "ViewController.h"
#import "NetworkClock.h"

@interface ViewController ()

@property(nonatomic, weak) IBOutlet UITextView *networkTimeTextView;

- (IBAction)disableNetwork:(id)sender;

@end

@implementation ViewController

- (void)setNetworkTimer
{
    [NetworkClock sharedInstance];
    NSTimer *timer = [[NSTimer alloc] initWithFireDate:[NSDate dateWithTimeIntervalSinceNow:1.0] interval:1.0 target:self selector:@selector(repeatPrint:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
}

- (NSTimer *)setNetworkTimerByGCD
{
    [NetworkClock sharedInstance];
    NSTimer *timer = [[NSTimer alloc] initWithFireDate:[NSDate dateWithTimeIntervalSinceNow:1.0] interval:1.0 target:self selector:@selector(repeatPrint:) userInfo:nil repeats:YES];
    return timer;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //    // 1. use nstimer to repeat get network time
    //    [self setNetworkTimer];
    
    // 2. Use GCD to get network time
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSTimer *timer = [self setNetworkTimerByGCD];
        dispatch_sync(dispatch_get_main_queue(), ^{
            [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
        });
    });
}

- (void)repeatPrint:(NSTimer *)timer
{
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.networkTimeTextView.text = [NSString stringWithFormat:@"%@",[[NetworkClock sharedInstance] networkTime]];
    });
}

- (void)dealloc
{
    [[NetworkClock sharedInstance] finishAssociations];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)disableNetwork:(id)sender
{
    [[NetworkClock sharedInstance] finishAssociations];
}

@end
