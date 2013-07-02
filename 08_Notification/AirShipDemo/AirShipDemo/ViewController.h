//
//  ViewController.h
//  AirShipDemo
//
//  Created by Kevin on 6/26/13.
//  Copyright (c) 2013 Kevin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property(nonatomic, weak) IBOutlet UITextField *deviceTokenTextField;

-(IBAction)testSendNotification:(id)sender;

@end
