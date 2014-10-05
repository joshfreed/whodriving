//
//  TripSpecification.m
//  whodriving
//
//  Created by Josh Freed on 10/4/14.
//  Copyright (c) 2014 Josh Freed. All rights reserved.
//

#import "TripSpecification.h"

@implementation TripSpecification

-(id)init:(NSNumber*)passengerCount possibleDrivers:(NSArray*)possibleDrivers
{
    self = [super init];
    self.passengerCount = passengerCount;
    self.possibleDrivers = possibleDrivers;
    return self;
}

@end
