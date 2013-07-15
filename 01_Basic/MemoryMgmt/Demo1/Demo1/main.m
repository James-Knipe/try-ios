//
//  main.m
//  Demo1
//
//  Created by Kevin on 7/15/13.
//  Copyright (c) 2013 aurora. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CarStore.h"
#import "Car.h"
#import "Person.h"

int main(int argc, const char * argv[])
{
    
    @autoreleasepool {
        
        // 1. Enabling MRR
        NSMutableArray *inventory = [[NSMutableArray alloc] init];
        [inventory addObject:@"Honda Civic"];
        
        CarStore *superstore = [[CarStore alloc] init];
        [superstore setInventory:inventory];
        [inventory release];
        // Do some other stuff...
        
        // Try to access the property later on (error!)
        NSLog(@"%@", [superstore inventory]);
        
        // 2.Properties example
        Person *john = [[Person alloc] init];
        john.name = @"John";
        
        Car *honda = [[Car alloc] init];
        honda.model = @"Honda Civic";
        honda.driver = john;
        NSLog(@"%@ is driving the %@", honda.driver, honda.model);
        john.car = honda;
        NSLog(@"=================");
        
        // The copy Attribute
        Car *honda2 = [[Car alloc] init];
        NSMutableString *model = [NSMutableString stringWithString:@"Honda Civic"];
        honda2.model = model;
        
        NSLog(@"%@", honda2.model);
        [model setString:@"Nissa Versa"];
        NSLog(@"%@", honda2.model);            // Still "Honda Civic"
    }
    return 0;
}

