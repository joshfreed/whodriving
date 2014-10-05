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
    for (Driver *driver in tripSpec.possibleDrivers) {
        DriverResult *result = [[DriverResult alloc] init];
        result.driver = driver;
        result.passengerCount = driver.numPassengers;
        [results addObject:result];
    }
    return results;
}

@end
