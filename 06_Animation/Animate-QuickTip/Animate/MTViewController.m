//
//  MTViewController.m
//  Animate
//
//  Created by C. A. Beninati on 4/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MTViewController.h"

@interface MTViewController ()
{
    int points;
}
@end

@implementation MTViewController

- (IBAction)didTouchAnimate:(UIButton*)sender {
    
    UIImage *starImage = [UIImage imageNamed:@"star.png"];
    UIImageView *starView = [[UIImageView alloc] initWithImage:starImage];
    [starView setCenter:sender.center];
    
    [UIView animateWithDuration:0.6f 
                          delay:0.1f 
                        options:UIViewAnimationCurveEaseOut
                     animations:^{
                         [starView setCenter:CGPointMake(0, 0)];
                         [starView setAlpha:0.6f];
                     } 
                     completion:^(BOOL finished){
                         [starView removeFromSuperview];
                         points++;
                         NSLog(@"points: %i", points);
                     }];     
    
    [self.view addSubview:starView];
}

@end
