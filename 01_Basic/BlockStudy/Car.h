//
//  Car.h
//  BlockDemo1
//
//  Created by Kevin on 7/14/13.
//  Copyright (c) 2013 aurora. All rights reserved.
//

#import <Foundation/Foundation.h>

// Define a new type for the block
typedef double (^SpeedFunction)(double);

@interface Car : NSObject

@property double odometer;

- (void)driveForDuration:(double)duration
       withVariableSpeed:(SpeedFunction)speedFunction
                   steps:(int)numSteps;

@end
