//
//  ViewController.m
//  AirShipDemo
//
//  Created by Kevin on 6/26/13.
//  Copyright (c) 2013 Kevin. All rights reserved.
//

#import "ViewController.h"
#import "UAPush.h"
#import "SuburbanAirship.h"

#define kiPhoneDevelopmentApplicationKey                @"Pa1LK73mQlioyEk_hIVvBA"
#define kiPhoneDevelopmentApplicationSecret             @"Au26N-y7SW6zCDSnUA8v5Q"
#define kiPhoneDevelopmentApplicationMasterSecret       @"hAmZkZmvQuuuD9FNfo62IA"

#define kiPadDevelopmentApplicationKey                  @"jCpHHk04ToiyYk6ek98Zsw"
#define kiPadDevelopmentApplicationSecret               @"MZjrqOHKQrSIih4TKZgm_w"
#define kiPadDevelopmentApplicationMasterSecret         @"rzof30icSxSNRUw3HCJPew"

#define kiPhoneDeviceToken @"F917EC02CF4ECA9E765EBA06F57A586FDB87897F8C5127D74D14A0B72C936BDD"
#define kiPadDeviceToken @"3AB48C15BA72214072A943B164EA4ECD9D134C6008126C71DF214DCFCEA67059"

@interface ViewController ()
{
    SuburbanAirship *suburbanAirship;
}
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [UAPush shared].alias = @"baimen.chen.iphone";
    [[UAPush shared] updateRegistration];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)testSendNotification:(id)sender
{
    [self sendToiPhone];
    [self sendToiPad];
}

- (void)sendToiPhone
{
    SuburbanAirshipNotification *saNotif = [SuburbanAirshipNotification alert:@"Test Message!"
                                                                        sound:@"notification.caf"
                                                                        badge:nil
                                                                         date:nil
                                                                  deviceToken:kiPhoneDeviceToken
                                                                          tag:nil
                                                                       queued:NO];
    if(suburbanAirship){
        [suburbanAirship setAppKey:kiPhoneDevelopmentApplicationKey];
        [suburbanAirship setAppSecret:kiPhoneDevelopmentApplicationSecret];
        [suburbanAirship setAppMaster:kiPhoneDevelopmentApplicationMasterSecret];
    } else {
        suburbanAirship = [[SuburbanAirship alloc] initWithDelegate:self
                                                                key:kiPhoneDevelopmentApplicationKey
                                                             secret:kiPhoneDevelopmentApplicationSecret
                                                             master:kiPhoneDevelopmentApplicationMasterSecret];
    }
    [suburbanAirship pushSuburbanAirshipNotification:saNotif];
}

- (void)sendToiPad
{
    SuburbanAirshipNotification *saNotif = [SuburbanAirshipNotification alert:@"Test Message!"
                                                                        sound:@"notification.caf"
                                                                        badge:nil
                                                                         date:nil
                                                                  deviceToken:kiPadDeviceToken
                                                                          tag:nil
                                                                       queued:NO];
    if(suburbanAirship){
        [suburbanAirship setAppKey:kiPadDevelopmentApplicationKey];
        [suburbanAirship setAppSecret:kiPadDevelopmentApplicationSecret];
        [suburbanAirship setAppMaster:kiPadDevelopmentApplicationMasterSecret];
    } else {
        suburbanAirship = [[SuburbanAirship alloc] initWithDelegate:self
                                                                key:kiPadDevelopmentApplicationKey
                                                             secret:kiPadDevelopmentApplicationSecret
                                                             master:kiPadDevelopmentApplicationMasterSecret];
    }
    [suburbanAirship pushSuburbanAirshipNotification:saNotif];
}

- (void)pushSucceeded:(NSArray *)aliases; {

}

- (void)pushFailed:(NSArray *)aliases {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Send notification failed", @"") message:NSLocalizedString(@"Retry push?", @"") delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"Cancel", @"")
                                          otherButtonTitles:NSLocalizedString(@"Retry", @""), nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
 
}

@end
