//
//  MTConstants.h
//  Four in a Row
//
//  Created by Kevin on 5/1/13.
//  Copyright (c) 2013 Kevin. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    MTGameStateUnknown = -1,
    MTGameStateMyTurn,
    MTGameStateYourTurn,
    MTGameStateIWin,
    MTGameStateYouWin
} MTGameState;

typedef enum {
    MTPlayerTypeMe = 0,
    MTPlayerTypeYou
} MTPlayerType;
