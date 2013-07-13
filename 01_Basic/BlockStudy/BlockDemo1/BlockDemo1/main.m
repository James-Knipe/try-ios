//
//  main.m
//  BlockDemo1
//
//  Created by Kevin on 7/14/13.
//  Copyright (c) 2013 aurora. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Car.h"

int main(int argc, const char * argv[])
{
    
    @autoreleasepool {
        // 1.Creating Blocks
        // Declare the block variable
        double (^distanceFromRateAndTime)(double rate, double time);
        
        // Create and assign the block
        distanceFromRateAndTime = ^double(double rate, double time) {
            return rate * time;
        };
        
        // Call the block
        double dx = distanceFromRateAndTime(35, 1.5);
        
        NSLog(@"A car driving 35 mph will travel "
              @"%.2f miles in 1.5 hours.", dx);
        
        
        // 2.Parameterless Blocks
        double (^randomPercent)(void) = ^ {
            return (double)arc4random() / 4294967295;
        };
        
        NSLog(@"Gas tank is %.1f%% full", randomPercent() * 100);
        
        
        // 3.Closures
        NSString *make = @"Honda";
        NSString *(^getFullCarName)(NSString *) = ^(NSString *mode1){
            return [make stringByAppendingFormat:@" %@",mode1];
        };
        NSLog(@"%@", getFullCarName(@"Accord"));
        
        // Try changing the non-local variable(it won't change the block)
        make = @"Porsche";
        NSLog(@"%@", getFullCarName(@"911 Turbo"));
        
        
        // 4.Mutable Non-Local Variables
        __block int i = 0;
        int (^count)(void) = ^ {
            i += 1;
            return i;
        };
        NSLog(@"%d", count());
        NSLog(@"%d", count());
        NSLog(@"%d", count());
        
        
        // 5.Block as Method Parameters
        Car *theCar = [[Car alloc] init];
        // Drive for awhile with constant speed of 5.0 m/s
        [theCar driveForDuration:10.0 withVariableSpeed:^double(double time) {
            return 5.0;
        } steps:100];
        NSLog(@"The car has now driven %.2f meters", theCar.odometer);
        
        // Start accelerating at a rate of 1.0 m/s^2
        [theCar driveForDuration:10.0 withVariableSpeed:^(double time) {
            return time + 0.5;
        } steps:100];
        NSLog(@"The car has now driven %.2f meters", theCar.odometer);
        
    }
    return 0;
}

