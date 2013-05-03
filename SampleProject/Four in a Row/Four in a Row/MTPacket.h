//
//  MTPacket.h
//  Four in a Row
//
//  Created by Kevin on 4/30/13.
//  Copyright (c) 2013 Kevin. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const MTPacketKeyData;
extern NSString * const MTPacketKeyType;
extern NSString * const MTPacketKeyAction;

typedef enum {
    MTPacketTypeUnknown = -1,
    MTPacketTypeDidAddDisc,
    MTPacketTypeStartNewGame
} MTPacketType;

typedef enum{
    MTPacketActionUnknown = -1
}MTPacketAction;

@interface MTPacket : NSObject

@property(strong, nonatomic) id data;
@property(assign, nonatomic) MTPacketType type;
@property(assign, nonatomic) MTPacketAction action;

#pragma mark -
#pragma mark Initialization
- (id)initWithData:(id)data type:(MTPacketType)type action:(MTPacketAction)action;

@end
