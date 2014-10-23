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
    NSMutableArray *results = [NSMutableArray array];
    
    NSArray *sortedDrivers = [tripSpec.possibleDrivers sortedArrayUsingComparator:^(id obj1, id obj2) {
        if (rand() % 2 == 0) {
            return NSOrderedAscending;
        } else {
            return NSOrderedDescending;
        }
    }];
    
    NSPredicate *capableDriverPredicate = [NSPredicate predicateWithBlock:^BOOL(Driver* driver, NSDictionary *bindings) {
        return driver.isEnabled && [driver.numPassengers intValue] + 1 >= [tripSpec.passengerCount intValue];
    }];
    NSArray *filteredArray = [sortedDrivers filteredArrayUsingPredicate:capableDriverPredicate];
    if (filteredArray.count > 0) {
        Driver *driver = filteredArray.firstObject;
        DriverResult *result = [[DriverResult alloc] init];
        result.driver = driver;
        result.passengerCount = driver.numPassengers;
        [results addObject:result];
        return results;
    }
    
    int satisfiedPassengers = 0;
    for (Driver *driver in sortedDrivers) {
        if (!driver.isEnabled) {
            continue;
        }
        
        DriverResult *result = [[DriverResult alloc] init];
        result.driver = driver;
        result.passengerCount = driver.numPassengers;
        [results addObject:result];
        
        satisfiedPassengers += [driver.numPassengers intValue] + 1;
        if (satisfiedPassengers >= [tripSpec.passengerCount intValue]) {
            break;
        }
    }
    return results;
}

@end
