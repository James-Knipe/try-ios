//
//  main.m
//  NSStringDemo
//
//  Created by Kevin on 8/1/13.
//  Copyright (c) 2013 aurora. All rights reserved.
//

#import <Foundation/Foundation.h>

int main(int argc, const char * argv[])
{

    @autoreleasepool {
        NSString *test = @"abcdef";
        NSUInteger bytes = [test lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
        NSLog(@"%lu byte", (unsigned long)bytes);
        
        NSString* string= @"myString";
        NSData* data=[string dataUsingEncoding:NSUTF8StringEncoding];
        NSUInteger myLength = data.length;
        NSLog(@"%lu byte", (unsigned long)myLength);
        
        NSData *byte1 = [string dataUsingEncoding:NSUTF8StringEncoding];
        NSLog(@"%lu byte", byte1.length);


    }
    return 0;
}

