//
//  CarStore.h
//  Demo1
//
//  Created by Kevin on 7/15/13.
//  Copyright (c) 2013 aurora. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CarStore : NSObject

+ (CarStore *)carStore;

- (NSMutableArray *)inventory;
- (void)setInventory:(NSMutableArray *)newInventory;

@end
