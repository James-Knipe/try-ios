//
//  main.m
//  DeepBlock
//
//  Created by Kevin on 7/15/13.
//  Copyright (c) 2013 aurora. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSArray+BlockExample.h"

int main(int argc, const char * argv[])
{
    
    @autoreleasepool {
        //1.The basics
        void(^block)(void) = ^{
            NSLog(@"I'm a block");
        };
        
        void(^block2)(int) = ^(int a){
            NSLog(@"I'm a block! a = %i", a);
        };
        
        int(^block3)(void) = ^{
            NSLog(@"I'm a block!");
            return 1;
        };
        
        int a = 1;
        void(^block4)(void) = ^{
            NSLog(@"I'm a block! a = %i", a);
        };
        
        // Demo2
        NSArray *array1 = [ NSArray arrayWithObjects: @"hello, world", [NSDate date], @"hello, universe", nil];
        NSArray *array2 = [NSArray arrayByFilteringArray:array1 withCallback:^BOOL(id element) {
            return [element isKindOfClass:[NSString class]];
        }];
        NSLog(@"%@", array2);
    }
    return 0;
}

