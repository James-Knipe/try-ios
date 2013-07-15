//
//  Car.h
//  Demo1
//
//  Created by Kevin on 7/15/13.
//  Copyright (c) 2013 aurora. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Person;

@interface Car : NSObject

@property(nonatomic) NSString *model;
@property(nonatomic, strong) Person *driver; 

@end
