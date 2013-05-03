//
//  MTHostGameViewController.h
//  Four in a Row
//
//  Created by Kevin on 4/30/13.
//  Copyright (c) 2013 Kevin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GCDAsyncSocket;

@interface MTHostGameViewController : UIViewController

@property(weak, nonatomic) id delegate;

@end

@protocol MTHostGameViewControllerDelegate

- (void)controller:(MTHostGameViewController *)controller didHostGameOnSocket:(GCDAsyncSocket *)socket;
- (void)controllerDidCancelHosting:(MTHostGameViewController *)controller;

@end
