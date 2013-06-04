//
//  MTLocationCell.m
//  Rain
//
//  Created by Bart Jacobs on 30/05/13.
//  Copyright (c) 2013 Mobile Tuts. All rights reserved.
//

#import "MTLocationCell.h"

#define kMTButtonDeleteWidth 44.0

#define kMTLabelLocationMarginLeft 44.0

@implementation MTLocationCell

#pragma mark -
#pragma mark Initialization
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        // Helpers
        CGSize size = self.contentView.frame.size;
        
        // Initialize Delete Button
        self.buttonDelete = [UIButton buttonWithType:UIButtonTypeCustom];
        
        // Configure Delete Button
        [self.buttonDelete setFrame:CGRectMake(0.0, 0.0, kMTButtonDeleteWidth, size.height)];
        [self.buttonDelete setImage:[UIImage imageNamed:@"button-delete-location-cell"] forState:UIControlStateNormal];
        [self.buttonDelete setImage:[UIImage imageNamed:@"button-delete-location-cell"] forState:UIControlStateSelected];
        [self.buttonDelete setImage:[UIImage imageNamed:@"button-delete-location-cell"] forState:UIControlStateDisabled];
        [self.buttonDelete setImage:[UIImage imageNamed:@"button-delete-location-cell"] forState:UIControlStateHighlighted];
        [self.buttonDelete setAutoresizingMask:(UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleRightMargin)];
        [self.contentView addSubview:self.buttonDelete];
        
        // Initialize Location Label
        self.labelLocation = [[UILabel alloc] initWithFrame:CGRectMake(kMTLabelLocationMarginLeft, 0.0, size.width - kMTLabelLocationMarginLeft, size.height)];
        
        // Configure Text Label
        [self.labelLocation setTextColor:kMTColorGray];
        [self.labelLocation setBackgroundColor:[UIColor clearColor]];
        [self.labelLocation setFont:[UIFont fontWithName:@"GillSans" size:20.0]];
        [self.labelLocation setAutoresizingMask:(UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin)];
        [self.contentView addSubview:self.labelLocation];
    }
    
    return self;
}

@end
