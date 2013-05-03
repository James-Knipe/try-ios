//
//  MTBoardCell.h
//  Four in a Row
//
//  Created by Kevin on 5/1/13.
//  Copyright (c) 2013 Kevin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    MTBoardCellTypeEmpty = -1,
    MTBoardCellTypeMine,
    MTBoardCellTypeYours
} MTBoardCellType;

@interface MTBoardCell : UIView

@property(assign, nonatomic) MTBoardCellType cellType;

@end
