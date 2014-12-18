//
//  Driver.m
//  whodriving
//
//  Created by Josh Freed on 9/20/14.
//  Copyright (c) 2014 Josh Freed. All rights reserved.
//

#import "Driver.h"

@implementation Driver

@dynamic driverName;
@dynamic numPassengers;
@dynamic isEnabled;
@dynamic createdOn;

- (void)setPassengerCount:(double)numPassengers {
    NSNumber *theNum = [NSNumber numberWithDouble:numPassengers];
    self.numPassengers = theNum;
}

- (void)enable
{
    self.isEnabled = true;
}

- (void)disable
{
    self.isEnabled = false;
}

- (NSComparisonResult)sortByName:(Driver*)aDriver
{
    return [self.driverName localizedCaseInsensitiveCompare:aDriver.driverName];
}

@end