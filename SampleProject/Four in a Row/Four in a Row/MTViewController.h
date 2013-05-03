//
//  MTViewController.h
//  Four in a Row
//
//  Created by Kevin on 4/30/13.
//  Copyright (c) 2013 Kevin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTViewController : UIViewController

@property(weak, nonatomic) IBOutlet UIView *boardView;
@property(weak, nonatomic) IBOutlet UIButton *hostButton;
@property(weak, nonatomic) IBOutlet UIButton *joinButton;
@property(weak, nonatomic) IBOutlet UIButton *replayButton;
@property(weak, nonatomic) IBOutlet UIButton *disconnectButton;
@property(weak, nonatomic) IBOutlet UILabel *gameStateLabel;

- (IBAction)hostGame:(id)sender;
- (IBAction)joinGame:(id)sender;
- (IBAction)replay:(id)sender;
- (IBAction)disconnect:(id)sender;


@end
