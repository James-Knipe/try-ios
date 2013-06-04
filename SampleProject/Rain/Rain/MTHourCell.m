//
//  MTHourCell.m
//  Rain
//
//  Created by Bart Jacobs on 30/05/13.
//  Copyright (c) 2013 Mobile Tuts. All rights reserved.
//

#import "MTHourCell.h"

#define kMTLabelBottomWidth 40.0
#define kMTLabelBottomHeight 40.0

@interface MTHourCell ()

@end

@implementation MTHourCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        // Helpers
        CGSize size = self.contentView.frame.size;
        
        // Initialize Label Time
        self.labelTime = [[UILabel alloc] initWithFrame:CGRectMake(30.0, 0.0, 50.0, 40.0)];
        
        // Configure Label Time
        [self.labelTime setBackgroundColor:[UIColor clearColor]];
        [self.labelTime setTextColor:[UIColor whiteColor]];
        [self.labelTime setFont:[UIFont fontWithName:@"GillSans-Light" size:18.0]];
        [self.labelTime setAutoresizingMask:(UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin)];
        [self.contentView addSubview:self.labelTime];
        
        // Initialize Label Temp
        self.labelTemp = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 46.0, 80.0, 44.0)];
        
        // Configure Label Temp
        [self.labelTemp setBackgroundColor:[UIColor clearColor]];
        [self.labelTemp setTextAlignment:NSTextAlignmentCenter];
        [self.labelTemp setTextColor:kMTColorGray];
        [self.labelTemp setFont:[UIFont fontWithName:@"GillSans-Bold" size:40.0]];
        [self.labelTemp setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin)];
        [self.contentView addSubview:self.labelTemp];
        
        // Initialize Label Wind
        self.labelWind = [[UILabel alloc] initWithFrame:CGRectMake(0.0, size.height - kMTLabelBottomHeight, kMTLabelBottomWidth, kMTLabelBottomHeight)];
        
        // Configure Label Wind
        [self.labelWind setBackgroundColor:[UIColor clearColor]];
        [self.labelWind setTextAlignment:NSTextAlignmentCenter];
        [self.labelWind setTextColor:kMTColorGray];
        [self.labelWind setFont:[UIFont fontWithName:@"GillSans-Light" size:16.0]];
        [self.labelWind setAutoresizingMask:(UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin)];
        [self.contentView addSubview:self.labelWind];
        
        // Initialize Label Rain
        self.labelRain = [[UILabel alloc] initWithFrame:CGRectMake(size.width - kMTLabelBottomWidth, size.height - kMTLabelBottomHeight, kMTLabelBottomWidth, kMTLabelBottomHeight)];
        
        // Configure Label Rain
        [self.labelRain setBackgroundColor:[UIColor clearColor]];
        [self.labelRain setTextAlignment:NSTextAlignmentCenter];
        [self.labelRain setTextColor:kMTColorGray];
        [self.labelRain setFont:[UIFont fontWithName:@"GillSans-Light" size:16.0]];
        [self.labelRain setAutoresizingMask:(UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin)];
        [self.contentView addSubview:self.labelRain];
        
        // Background View
        UIImage *backgroundImage = [[UIImage imageNamed:@"background-hour-cell"] resizableImageWithCapInsets:UIEdgeInsetsMake(40.0, 10.0, 10.0, 10.0)];
        UIImageView *backgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, size.width, size.height)];
        [backgroundView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
        [backgroundView setImage:backgroundImage];
        [self setBackgroundView:backgroundView];
    }
    
    return self;
}

@end
