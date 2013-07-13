//
//  Car.m
//  BlockDemo1
//
//  Created by Kevin on 7/14/13.
//  Copyright (c) 2013 aurora. All rights reserved.
//

#import "Car.h"

@implementation Car

@synthesize odometer = _odometer;

- (void)driveForDuration:(double)duration
       withVariableSpeed:(SpeedFunction)speedFunction
                   steps:(int)numSteps {
    double dt = duration / numSteps;
    for (int i=1; i<=numSteps; i++) {
        _odometer += speedFunction(i*dt) * dt;
    }
}

@end
