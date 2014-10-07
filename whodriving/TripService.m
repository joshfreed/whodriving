//
//  TripService.m
//  whodriving
//
//  Created by Josh Freed on 10/4/14.
//  Copyright (c) 2014 Josh Freed. All rights reserved.
//

#import "TripService.h"
#import "Driver.h"
#import "DriverResult.h"

@implementation TripService

-(NSArray*)buildTrip:(TripSpecification*)tripSpec
{
    NSArray *sortedDrivers = [tripSpec.possibleDrivers sortedArrayUsingComparator:^(id obj1, id obj2) {
        if (rand() % 2 == 0) {
            return NSOrderedAscending;
        } else {
            return NSOrderedDescending;
        }
    }];
    NSMutableArray *results = [NSMutableArray array];
    int satisfiedPassengers = 0;
    for (Driver *driver in sortedDrivers) {
        if (!driver.isEnabled) {
            continue;
        }
        
        DriverResult *result = [[DriverResult alloc] init];
        result.driver = driver;
        result.passengerCount = driver.numPassengers;
        [results addObject:result];
        
        satisfiedPassengers += [driver.numPassengers intValue];
        if (satisfiedPassengers >= [tripSpec.passengerCount intValue]) {
            break;
        }
    }
    return results;
}

@end
