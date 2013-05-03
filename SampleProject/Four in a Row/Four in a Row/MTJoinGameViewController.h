//
//  MTJoinGameViewController.h
//  Four in a Row
//
//  Created by Kevin on 4/30/13.
//  Copyright (c) 2013 Kevin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GCDAsyncSocket;
@interface MTJoinGameViewController : UITableViewController

@property(weak, nonatomic) id delegate;

@end

@protocol MTJoinGameViewControllerDelegate

- (void)controller:(MTJoinGameViewController *)controller didJoinGameOnSocket:(GCDAsyncSocket *)socket;
- (void)controllerDidCancelJoining:(MTJoinGameViewController *)controller;

@end