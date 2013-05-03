//
//  MTGameController.h
//  Four in a Row
//
//  Created by Kevin on 4/30/13.
//  Copyright (c) 2013 Kevin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GCDAsyncSocket;
@protocol MTGameControllerDelegate;
@interface MTGameController : NSObject

@property(weak, nonatomic) id<MTGameControllerDelegate> delegate;

#pragma mark -
#pragma mark Initialization
- (id)initWithSocket:(GCDAsyncSocket *)socket;
- (void)testConnection;
#pragma mark -
#pragma mark Public Instance Methods
- (void)startNewGame;
- (void)addDiscToColumn:(NSInteger)column;

@end

@protocol MTGameControllerDelegate

- (void)controllerDidDisconnect:(MTGameController *)controller;
- (void)controller:(MTGameController *)controller didAddDiscToColumn:(NSInteger)column;
- (void)controllerDidStartNewGame:(MTGameController *)controller;

@end

