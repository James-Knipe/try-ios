//
//  MTHostGameViewController.m
//  Four in a Row
//
//  Created by Kevin on 4/30/13.
//  Copyright (c) 2013 Kevin. All rights reserved.
//

#import "MTHostGameViewController.h"
#import "MTPacket.h"

@interface MTHostGameViewController ()<NSNetServiceDelegate, GCDAsyncSocketDelegate>

@property(strong, nonatomic) NSNetService *service;
@property(strong, nonatomic) GCDAsyncSocket *socket;

@end

@implementation MTHostGameViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Setup View
    [self setupView];
    [self startBroadcast];
}

- (void)setupView
{
    // Create Cancel Button
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
}

- (void)startBroadcast
{
    // Initialize GCDAsynSocket
    self.socket = [[GCDAsyncSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    // Start Listening for Incoming Connections
    NSError *error = nil;
    if([self.socket acceptOnPort:0 error:&error]){
        // Initialize Service
        self.service = [[NSNetService alloc] initWithDomain:@"local" type:@"_fourinarow._tcp." name:@"" port:[self.socket localPort]];
        // Configue Service
        self.service.delegate = self;
        // Publish Service
        [self.service publish];
    } else {
        NSLog(@"Unable to create socket. Error %@ with user info %@.", error, [error userInfo]);
    }
}

- (void)cancel:(id)sender
{
    // Cancel Hosting Game
    [self.delegate controllerDidCancelHosting:self];
    // End Broadcast
    [self endBroadcast];
    // Dismiss view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)endBroadcast
{
    if(self.socket){
        [self.socket setDelegate:nil delegateQueue:NULL];
        [self setSocket:nil];
    }
    if(self.service){
        [self.service setDelegate:nil];
        [self setService:nil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    if(_delegate){
        _delegate = nil;
    }
    if(_socket){
        [_socket setDelegate:nil delegateQueue:NULL];
        _socket = nil;
    }
}

#pragma NSNetServiceDelegate
- (void)netServiceDidPublish:(NSNetService *)sender
{
    NSLog(@"Bonjour Service Published: domain(%@) type(%@) name(%@) port(%i)", [sender domain], [sender type], [sender name], (int)[sender port]);
}

- (void)netService:(NSNetService *)sender didNotPublish:(NSDictionary *)errorDict
{
    NSLog(@"Failed to Publish Service: domain(%@) type(%@) name(%@) - %@", [sender domain], [sender type], [sender name], errorDict);
}

#pragma GCDAsyncSocketDelegate
- (void)socket:(GCDAsyncSocket *)sock didAcceptNewSocket:(GCDAsyncSocket *)newSocket
{
    NSLog(@"Accepted New Socket from %@:%hu",[newSocket connectedHost], [newSocket connectedPort]);

    // Notify Delegate
    [self.delegate controller:self didHostGameOnSocket:newSocket];
    // End BroadCast
    [self endBroadcast];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
