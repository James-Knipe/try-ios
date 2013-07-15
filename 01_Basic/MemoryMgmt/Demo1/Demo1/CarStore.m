//
//  CarStore.m
//  Demo1
//
//  Created by Kevin on 7/15/13.
//  Copyright (c) 2013 aurora. All rights reserved.
//

#import "CarStore.h"

@implementation CarStore{
    NSMutableArray *_inventory;
}


+ (CarStore *)carStore
{
    CarStore *newStore = [[CarStore alloc] init];
    return [newStore autorelease];
}

- (NSMutableArray *)inventory
{
    return _inventory;
}

- (void)setInventory:(NSMutableArray *)newInventory
{
    if(_inventory == newInventory){
        return;
    }
    NSMutableArray *oldValue = _inventory;
    _inventory = [newInventory retain];
    //_inventory = [newInventory copy];
    [oldValue release];;
}

- (void)dealloc
{
    [_inventory release];
    [super dealloc];
}

@end
