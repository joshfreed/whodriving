//
//  TripSpecification.m
//  whodriving
//
//  Created by Josh Freed on 10/4/14.
//  Copyright (c) 2014 Josh Freed. All rights reserved.
//

#import "TripSpecification.h"
#import "Driver.h"

@implementation TripSpecification

- (id)init {
    if (self = [super init]) {
        self.passengerCount = 6;
        self.possibleDrivers = [NSArray array];
    }
    return self;
}

- (void)increasePersonCount {
    self.passengerCount++;
    if (self.passengerCount > 99) {
        self.passengerCount = 99;
    }
}

- (void)decreasePersonCount {
    self.passengerCount--;
    if (self.passengerCount < 1) {
        self.passengerCount = 1;
    }
}

- (bool)isSatisfiedBy:(NSArray*)driverSet
{
    int satisfiedPeople = 0;
    
    for (Driver *driver in driverSet) {
        satisfiedPeople += [driver.numPassengers intValue] + 1;
        if (satisfiedPeople >= self.passengerCount) {
            return YES;
        }
    }

    return NO;
}

@end
