//
//  MTGameController.m
//  Four in a Row
//
//  Created by Kevin on 4/30/13.
//  Copyright (c) 2013 Kevin. All rights reserved.
//

#import "MTGameController.h"
#import "MTPacket.h"

#define TAG_HEAD 0
#define TAG_BODY 1

@interface MTGameController ()

@property(strong, nonatomic) GCDAsyncSocket *socket;

@end

@implementation MTGameController

#pragma mark -
#pragma mark Initialization
- (id)initWithSocket:(GCDAsyncSocket *)socket
{
    self = [super init];
    if(self){
        self.socket = socket;
        self.socket.delegate = self;
        // start Reading Data
        [self.socket readDataToLength:sizeof(uint64_t) withTimeout:-1.0 tag:TAG_HEAD];
    }
    return self;
}

- (void)sendPacket:(MTPacket *)packet {
    // Encode Packet Data
    NSMutableData *packetData = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:packetData];
    [archiver encodeObject:packet forKey:@"packet"];
    [archiver finishEncoding];
    // Initialize Buffer
    NSMutableData *buffer = [[NSMutableData alloc] init];
    // Fill Buffer
    uint64_t headerLength = [packetData length];
    [buffer appendBytes:&headerLength length:sizeof(uint64_t)];
    [buffer appendBytes:[packetData bytes] length:[packetData length]];
    // Write Buffer
    [self.socket writeData:buffer withTimeout:-1.0 tag:0];
}

- (uint64_t)parseHeader:(NSData *)data {
    uint64_t headerLength = 0;
    memcpy(&headerLength, [data bytes], sizeof(uint64_t));
    return headerLength;
}

- (void)parseBody:(NSData *)data {
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    MTPacket *packet = [unarchiver decodeObjectForKey:@"packet"];
    [unarchiver finishDecoding];
    /*
    NSLog(@"Packet Data > %@", packet.data);
    NSLog(@"Packet Type > %i", packet.type);
    NSLog(@"Packet Action > %i", packet.action);
     */
    if([packet type] == MTPacketTypeDidAddDisc){
        NSNumber *column = [(NSDictionary *)[packet data] objectForKey:@"column"];
        if(column){
            // Notify Delegate
            [self.delegate controller:self didAddDiscToColumn:[column integerValue]];
        }
    } else if ([packet type] == MTPacketTypeStartNewGame) {
        // Notify Delegate
        [self.delegate controllerDidStartNewGame:self];
    }
}

- (void)testConnection
{
    // Create Packet
    NSString *message = @"This is a proof of concept.";
    MTPacket *packet = [[MTPacket alloc] initWithData:message type:0 action:0];
    // Send Packet
    [self sendPacket:packet];
}

- (void)startNewGame {
    // Send Packet
    NSDictionary *load = nil;
    MTPacket *packet = [[MTPacket alloc] initWithData:load type:MTPacketTypeStartNewGame action:0];
    [self sendPacket:packet];
}

- (void)addDiscToColumn:(NSInteger)column
{
    // Send Packet
    NSDictionary *load = @{@"column":@(column)};
    MTPacket *packet = [[MTPacket alloc] initWithData:load type:MTPacketTypeDidAddDisc action:0];
    [self sendPacket:packet];
}

- (void)dealloc {
    if (_socket) {
        [_socket setDelegate:nil delegateQueue:NULL];
        [_socket disconnect];
        _socket = nil;
    }
}

#pragma mark -
#pragma mark GCDAsyncSocketDelegate
- (void)socketDidDisconnect:(GCDAsyncSocket *)socket withError:(NSError *)error {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    if (self.socket == socket) {
        [self.socket setDelegate:nil];
        [self setSocket:nil];
    }
    // Notify Delegate
    [self.delegate controllerDidDisconnect:self];
}

- (void)socket:(GCDAsyncSocket *)socket didReadData:(NSData *)data withTag:(long)tag {
    if (tag == 0) {
        uint64_t bodyLength = [self parseHeader:data];
        [socket readDataToLength:bodyLength withTimeout:-1.0 tag:1];
    } else if (tag == 1) {
        [self parseBody:data];
        [socket readDataToLength:sizeof(uint64_t) withTimeout:-1.0 tag:0];
    }
}

@end
