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

-(id)init:(NSNumber*)passengerCount
{
    self = [super init];
    self.passengerCount = passengerCount;
    return self;
}

-(id)init:(NSNumber*)passengerCount possibleDrivers:(NSArray*)possibleDrivers
{
    self = [super init];
    self.passengerCount = passengerCount;
    self.possibleDrivers = possibleDrivers;
    return self;
}

-(bool)isSatisfiedBy:(NSArray*)driverSet
{
    int satisfiedPeople = 0;
    
    for (Driver *driver in driverSet) {
        satisfiedPeople += [driver.numPassengers intValue] + 1;
        if (satisfiedPeople >= [self.passengerCount intValue]) {
            return YES;
        }
    }

    return NO;
}

@end
