//
//  Person.h
//  Demo1
//
//  Created by Kevin on 7/15/13.
//  Copyright (c) 2013 aurora. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Car;

@interface Person : NSObject

@property(nonatomic, copy) NSString *name;
@property(nonatomic, strong) Car *car;
// only in ARC
//@property(nonatomic, weak) Car *car;
@end
