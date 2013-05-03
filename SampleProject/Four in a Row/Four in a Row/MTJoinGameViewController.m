//
//  MTJoinGameViewController.m
//  Four in a Row
//
//  Created by Kevin on 4/30/13.
//  Copyright (c) 2013 Kevin. All rights reserved.
//

#import "MTJoinGameViewController.h"
#import "MTPacket.h"

@interface MTJoinGameViewController ()<NSNetServiceDelegate, NSNetServiceBrowserDelegate, GCDAsyncSocketDelegate>

@property(strong, nonatomic) GCDAsyncSocket *socket;
@property(strong, nonatomic) NSMutableArray *services;
@property(strong, nonatomic) NSNetServiceBrowser *serviceBrowser;

@end

@implementation MTJoinGameViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupView];
    [self startBrowsing];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
}

- (void)setupView
{
    // Create cancel button
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
}

- (void)cancel:(id)sender
{
    // Notify Delegate
    [self.delegate controllerDidCancelJoining:self];
    // Stop Browsing Services
    [self stopBrowsing];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)startBrowsing
{
    if(self.services){
        [self.services removeAllObjects];
    } else {
        self.services = [NSMutableArray array];
    }
    // Initialize Service Browser
    self.serviceBrowser = [[NSNetServiceBrowser alloc] init];
    // Configure Service Browser
    [self.serviceBrowser setDelegate:self];
    [self.serviceBrowser searchForServicesOfType:@"_fourinarow._tcp." inDomain:@"local."];
}

- (void)stopBrowsing
{
    if(self.serviceBrowser){
        [self.serviceBrowser stop];
        [self.serviceBrowser setDelegate:nil];
        [self setServiceBrowser:nil];
    }
}

- (BOOL)connectWithService:(NSNetService *)service
{
    BOOL _isConnected = NO;
    // Copy Service Address
    NSArray *addresses = [[service addresses] mutableCopy];
    if(!self.socket || ![self.socket isConnected]){
        // Initialize Socket
        self.socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
        while (!_isConnected && [addresses count]) {
            NSData *address = [addresses objectAtIndex:0];
            NSError *error = nil;
            if([self.socket connectToAddress:address error:&error]){
                _isConnected = YES;
            } else if(error){
                NSLog(@"Unable to connect to address. Error %@ with user info %@", error, [error userInfo]);
            }
        }
    } else {
        _isConnected = [self.socket isConnected];
    }
    return _isConnected;
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
//    if(_socket){
//        [_socket setDelegate:nil delegateQueue:NULL];
//        _socket = nil;
//    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.services ? 1 : 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.services.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (!cell) {
        // Initialize Table View Cell
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    // Fetch Service
    NSNetService *service = [self.services objectAtIndex:[indexPath row]];
    cell.textLabel.text = service.name;
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    // Fetch Service
    NSNetService *service = [self.services objectAtIndex:[indexPath row]];
    // Resolve Service
    [service setDelegate:self];
    [service resolveWithTimeout:30.0];
}

#pragma NSNetServiceBrowserDelegate
- (void)netServiceBrowser:(NSNetServiceBrowser *)aNetServiceBrowser didFindService:(NSNetService *)aNetService moreComing:(BOOL)moreComing
{
    [self.services addObject:aNetService];
    if(!moreComing){
        // Sort Services
        [self.services sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]]];
        // Update Table View
        [self.tableView reloadData];
    }
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)aNetServiceBrowser didRemoveService:(NSNetService *)aNetService moreComing:(BOOL)moreComing
{
    [self.services removeObject:aNetService];
    if(!moreComing){
        [self.tableView reloadData];
    }
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)aNetServiceBrowser didNotSearch:(NSDictionary *)errorDict
{
    [self stopBrowsing];
}

- (void)netServiceBrowserDidStopSearch:(NSNetServiceBrowser *)aNetServiceBrowser
{
    [self stopBrowsing];
}

# pragma NSNetServiceDelegate
- (void)netService:(NSNetService *)sender didNotResolve:(NSDictionary *)errorDict
{
    [sender setDelegate:nil];
}

- (void)netServiceDidResolveAddress:(NSNetService *)service
{
    // Connect with service
    if ([self connectWithService:service]) {
        NSLog(@"Did Connect with Service: domain(%@) type(%@) name(%@) port(%i)", [service domain], [service type], [service name], (int)[service port]);
    } else {
        NSLog(@"Unable to Connect with Service: domain(%@) type(%@) name(%@) port(%i)", [service domain], [service type], [service name], (int)[service port]);
    }
}

# pragma GCDAsyncSocketDelegate
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    NSLog(@"Socket Did Connect to Host: %@ Port: %hu", host, port);
    [self.delegate controller:self didJoinGameOnSocket:sock];
    // Stop Browsing
    [self stopBrowsing];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    NSLog(@"Socket Did Disconnect with Error %@ with user info %@", err, [err userInfo]);
    [sock setDelegate:nil];
    [self setSocket:nil];
}

@end
