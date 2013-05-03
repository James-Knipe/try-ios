//
//  MTBoardCell.m
//  Four in a Row
//
//  Created by Kevin on 5/1/13.
//  Copyright (c) 2013 Kevin. All rights reserved.
//

#import "MTBoardCell.h"

@implementation MTBoardCell

#pragma mark -
#pragma mark Initialization
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.cellType = MTBoardCellTypeEmpty;
    }
    return self;
}

#pragma mark -
#pragma mark Setters & Getters
- (void)setCellType:(MTBoardCellType)cellType
{
    if(_cellType != cellType){
        _cellType = cellType;
        // Update View
        [self updateView];
    }
}

#pragma mark -
#pragma mark Helper Methods
- (void)updateView
{
    // Background Color
    self.backgroundColor = (self.cellType == MTBoardCellTypeMine) ? [UIColor yellowColor] : (self.cellType == MTBoardCellTypeYours) ? [UIColor redColor] : [UIColor whiteColor];
}

@end
