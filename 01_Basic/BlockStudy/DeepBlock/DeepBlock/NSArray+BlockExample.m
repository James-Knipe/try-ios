//
//  NSArray+BlockExample.m
//  DeepBlock
//
//  Created by Kevin on 7/15/13.
//  Copyright (c) 2013 aurora. All rights reserved.
//

#import "NSArray+BlockExample.h"

@implementation NSArray (BlockExample)

+ (NSArray *)arrayByFilteringArray:(NSArray *)source withCallback:(BOOL (^)(id))callback
{
    NSMutableArray *result;
    id element;
    result = [NSMutableArray arrayWithCapacity:[source count]];
    for (element in source) {
        if(callback(element)){
            [result addObject:element];
        }
    }
    return result;
}

@end
