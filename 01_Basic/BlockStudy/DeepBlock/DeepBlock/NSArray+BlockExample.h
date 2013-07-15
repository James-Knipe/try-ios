//
//  NSArray+BlockExample.h
//  DeepBlock
//
//  Created by Kevin on 7/15/13.
//  Copyright (c) 2013 aurora. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (BlockExample)

+ (NSArray *)arrayByFilteringArray:(NSArray *)source withCallback:(BOOL (^)(id))callback;

@end
